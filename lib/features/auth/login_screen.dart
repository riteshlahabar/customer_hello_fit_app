import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/hf_display_heading.dart';
import '../../core/widgets/hf_logo.dart';
import '../../core/widgets/hf_primary_button.dart';
import '../../core/widgets/hf_text_field.dart';
import 'auth_controller.dart';
import 'otp_screen.dart';
import 'widgets/auth_footer_note.dart';
import 'widgets/form_error_text.dart';

/// Page 05. Mobile number in, OTP out.
///
/// The design also draws a password field, a "Forgot password?" link and a
/// Google button. None of the three exist in the backend — `/auth/otp/verify`
/// takes a mobile and a code, and there is no password column anywhere — so
/// they are deliberately not drawn. Flagged to the client; do not add them
/// back without an API behind them.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mobile = TextEditingController();

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _mobile.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final mobile = _mobile.text.trim();

    // Checked here as well as on the server so a plainly wrong number costs
    // nothing from the five-a-minute OTP budget.
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      setState(() => _error = 'Enter a valid 10-digit mobile number.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final result = await ref.read(authControllerProvider.notifier).sendOtp(mobile);

    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case ApiSuccess(:final data):
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => OtpScreen(mobile: mobile, devCode: data.devCode),
          ),
        );
      case ApiFailure(:final code, :final message):
        setState(() {
          _error = code == ApiErrorCode.rateLimited
              ? 'Too many attempts. Wait a minute and try again.'
              : message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set when a session ended on its own, so the screen can say why.
    final expired = switch (ref.watch(authControllerProvider)) {
      AuthSignedOut(:final reason) => reason,
      _ => null,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: ListView(
            children: [
              const SizedBox(height: 27),
              const Center(child: HFLogo(height: 62)),
              const SizedBox(height: 22),
              const HFKicker('Welcome back', align: TextAlign.center),
              const SizedBox(height: HFSpacing.sm),
              const HFDisplayHeading(
                runs: [
                  HFHeadingRun("LET'S GET "),
                  HFHeadingRun.accent('MOVING.'),
                ],
                align: TextAlign.center,
              ),
              const SizedBox(height: 9),
              const Text(
                'Log in to continue your fitness journey with HelloFit.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 11.5,
                  height: 1.7,
                  color: HFColors.muted,
                ),
              ),
              if (expired != null) ...[
                const SizedBox(height: HFSpacing.md),
                FormErrorText(expired),
              ],
              const SizedBox(height: 26),
              HFTextField(
                label: 'Mobile number',
                controller: _mobile,
                hint: 'Enter your mobile number',
                prefix: '+91',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                enabled: !_busy,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (_) => _busy ? null : _sendOtp(),
              ),
              if (_error != null) ...[
                const SizedBox(height: HFSpacing.sm),
                FormErrorText(_error!),
              ],
              const SizedBox(height: 19),
              HFPrimaryButton(
                label: 'Login',
                busy: _busy,
                onPressed: _sendOtp,
              ),
              const SizedBox(height: 14),
              const Text(
                "We'll text you a 6-digit code to confirm it's you. "
                'A new number creates your HelloFit account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 10,
                  height: 1.6,
                  color: HFColors.softMuted,
                ),
              ),
              const SizedBox(height: 34),
              const AuthFooterNote(
                'By continuing, you agree to our Terms of Service and '
                'Privacy Policy.',
              ),
              const SizedBox(height: HFSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
