import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/theme/tokens.dart';
import 'auth_controller.dart';

/// Mobile OTP sign-in. Structural only — layout is placeholder until the
/// designs arrive; what matters here is the two-step flow and the error-code
/// handling against the backend.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mobile = TextEditingController();
  final _code = TextEditingController();

  bool _codeSent = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _mobile.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    final result = await ref
        .read(authControllerProvider.notifier)
        .sendOtp(_mobile.text.trim());

    if (!mounted) return;

    switch (result) {
      case ApiSuccess(:final data):
        setState(() {
          _codeSent = true;
          _busy = false;
          // Development convenience only; the backend omits this in
          // production once the SMS provider is live.
          if (data.devCode != null) _code.text = data.devCode!;
        });
      case ApiFailure(:final message):
        setState(() {
          _busy = false;
          _error = message;
        });
    }
  }

  Future<void> _verify() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    final result = await ref.read(authControllerProvider.notifier).verifyOtp(
          mobile: _mobile.text.trim(),
          code: _code.text.trim(),
        );

    if (!mounted) return;

    // On success the router reacts to the auth state; nothing to do here.
    if (result case ApiFailure(:final code, :final message)) {
      setState(() {
        _busy = false;
        _error = switch (code) {
          ApiErrorCode.otpExpired => 'That code expired. Request a new one.',
          ApiErrorCode.otpAttemptsExceeded =>
            'Too many incorrect attempts. Request a new code.',
          ApiErrorCode.otpInvalid => 'Incorrect code.',
          _ => message,
        };

        // An expired or burnt-out code means starting the step again.
        if (code == ApiErrorCode.otpExpired ||
            code == ApiErrorCode.otpAttemptsExceeded) {
          _codeSent = false;
          _code.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(HFSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('HelloFit', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: HFSpacing.xs),
              const Text(
                'Home yoga and wellness',
                style: TextStyle(color: HFColors.muted),
              ),
              const SizedBox(height: HFSpacing.xl),
              TextField(
                controller: _mobile,
                enabled: !_codeSent && !_busy,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Mobile number',
                  counterText: '',
                  prefixText: '+91  ',
                ),
              ),
              if (_codeSent) ...[
                const SizedBox(height: HFSpacing.md),
                TextField(
                  controller: _code,
                  enabled: !_busy,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Enter the 6-digit code',
                    counterText: '',
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: HFSpacing.md),
                Text(_error!, style: const TextStyle(color: HFColors.primary)),
              ],
              const SizedBox(height: HFSpacing.lg),
              ElevatedButton(
                onPressed: _busy ? null : (_codeSent ? _verify : _sendOtp),
                child: _busy
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_codeSent ? 'Verify and continue' : 'Send code'),
              ),
              if (_codeSent)
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() {
                            _codeSent = false;
                            _code.clear();
                            _error = null;
                          }),
                  child: const Text('Change number'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
