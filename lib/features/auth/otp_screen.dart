import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/hf_display_heading.dart';
import '../../core/widgets/hf_logo.dart';
import '../../core/widgets/hf_primary_button.dart';
import 'auth_controller.dart';
import 'widgets/auth_footer_note.dart';
import 'widgets/form_error_text.dart';
import 'widgets/otp_code_field.dart';
import 'widgets/otp_screen_parts.dart';
import 'widgets/otp_verify_icon.dart';

/// Page 06. Pushed by the login screen, so "Edit" and "Change mobile number"
/// are a pop — the back gesture and the links then agree.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.mobile, this.devCode});

  final String mobile;

  /// Only ever set while the backend runs without an SMS provider; it fills
  /// the boxes so a tester is not blocked. Never sent in production.
  final String? devCode;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _codeKey = GlobalKey<OtpCodeFieldState>();

  String _code = '';
  bool _busy = false;
  String? _error;
  String? _notice;

  /// `/auth/otp/send` allows five a minute per IP, and a 429 cascade looks
  /// exactly like a broken screen, so Resend is held shut in between.
  static const _cooldownSeconds = 45;
  int _secondsLeft = _cooldownSeconds;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    if (widget.devCode != null) _fill(widget.devCode!);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _ticker?.cancel();
    setState(() => _secondsLeft = _cooldownSeconds);

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  /// The field is built on the next frame, so the code cannot be handed over
  /// until it exists.
  void _fill(String code) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeKey.currentState?.fill(code);
    });
  }

  Future<void> _verify() async {
    if (_code.length != 6) {
      setState(() => _error = 'Enter all six digits.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });

    final result = await ref.read(authControllerProvider.notifier).verifyOtp(
          mobile: widget.mobile,
          code: _code,
        );

    if (!mounted) return;

    if (result case ApiSuccess()) {
      // The root screen has already swapped underneath; drop this route so
      // the customer is not left looking at a spent OTP form.
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    if (result case ApiFailure(:final code, :final message)) {
      setState(() {
        _busy = false;
        _error = switch (code) {
          ApiErrorCode.otpExpired => 'That code expired. Request a new one.',
          ApiErrorCode.otpAttemptsExceeded =>
            'Too many incorrect attempts. Request a new code.',
          ApiErrorCode.otpInvalid => 'Incorrect code. Check and try again.',
          _ => message,
        };
      });

      _codeKey.currentState?.clear();

      // A burnt-out code is only recoverable by resending, so open that up
      // rather than making the customer wait out the cooldown.
      if (code == ApiErrorCode.otpExpired ||
          code == ApiErrorCode.otpAttemptsExceeded) {
        _ticker?.cancel();
        setState(() => _secondsLeft = 0);
      }
    }
  }

  Future<void> _resend() async {
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });

    final result =
        await ref.read(authControllerProvider.notifier).sendOtp(widget.mobile);

    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case ApiSuccess(:final data):
        _codeKey.currentState?.clear();
        _startCooldown();
        setState(() => _notice = 'A new code is on its way.');
        if (data.devCode != null) _fill(data.devCode!);
      case ApiFailure(:final code, :final message):
        setState(() {
          _error = code == ApiErrorCode.rateLimited
              ? 'Too many requests. Wait a minute before asking again.'
              : message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _secondsLeft <= 0 && !_busy;
    final back = _busy ? null : () => Navigator.of(context).pop();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Center(child: HFLogo(height: 54)),
              const SizedBox(height: 30),
              const Center(child: OtpVerifyIcon()),
              const SizedBox(height: 24),
              const HFKicker(
                'One quick security check',
                align: TextAlign.center,
              ),
              const SizedBox(height: 9),
              const HFDisplayHeading(
                runs: [
                  HFHeadingRun('VERIFY YOUR '),
                  HFHeadingRun.accent('NUMBER.'),
                ],
                fontSize: 36,
                align: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "We've sent a 6-digit verification code to your mobile number.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 11.5,
                  height: 1.7,
                  color: HFColors.muted,
                ),
              ),
              const SizedBox(height: 10),
              OtpNumberLine(mobile: widget.mobile, onEdit: back),
              const SizedBox(height: 30),
              OtpCodeField(
                key: _codeKey,
                enabled: !_busy,
                onChanged: (code) => setState(() => _code = code),
                onCompleted: (_) => _verify(),
              ),
              const SizedBox(height: 14),
              if (_error != null)
                FormErrorText(_error!, align: TextAlign.center)
              else
                OtpResendLine(
                  canResend: canResend,
                  secondsLeft: _secondsLeft,
                  notice: _notice,
                  onResend: _resend,
                ),
              const SizedBox(height: 24),
              HFPrimaryButton(
                label: 'Verify & Continue',
                busy: _busy,
                onPressed: _verify,
              ),
              const SizedBox(height: 20),
              OtpChangeNumberLine(onTap: back),
              const SizedBox(height: 30),
              const AuthFooterNote(
                'Your number is only used to secure your HelloFit account.',
              ),
              const SizedBox(height: HFSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
