import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/hf_display_heading.dart';
import '../../core/widgets/hf_logo.dart';
import '../../core/widgets/hf_primary_button.dart';
import '../../core/widgets/hf_text_field.dart';
import 'auth_controller.dart';
import 'widgets/form_error_text.dart';
import 'widgets/terms_checkline.dart';
import 'widgets/verified_mobile_field.dart';

/// Page 07, reached after OTP verification when the profile has no name yet.
///
/// The design draws Password and Confirm password. There is no password
/// anywhere in this system — `/auth/otp/verify` is the only way in — so the
/// pair is deliberately not drawn, and the mobile is shown locked because it
/// is the identity that was just verified, not a field to fill. Flagged to
/// the client.
///
/// This is a `PATCH`, not a create: the backend made the profile row during
/// verification and says a POST "would always be a conflict".
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, required this.mobile});

  final String mobile;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();

  bool _agreed = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_first.text.trim().isEmpty) return 'Enter your first name.';
    if (_last.text.trim().isEmpty) return 'Enter your last name.';

    final email = _email.text.trim();
    if (email.isEmpty) return 'Enter your email address.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }

    if (!_agreed) return 'Accept the Terms of Service to continue.';
    return null;
  }

  Future<void> _submit() async {
    final problem = _validate();
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    // The profile carries one `name`; the design asks for two fields, so
    // they are joined here rather than inventing a column for each.
    final result = await ref.read(profileRepositoryProvider).updateProfile(
          name: '${_first.text.trim()} ${_last.text.trim()}',
          email: _email.text.trim(),
        );

    if (!mounted) return;

    switch (result) {
      case ApiSuccess():
        await ref.read(authControllerProvider.notifier).completeRegistration();
      case ApiFailure(:final message, :final validationMessages):
        setState(() {
          _busy = false;
          // A 400 names the offending field; that is more use than the
          // envelope's generic line.
          _error = validationMessages.isEmpty
              ? message
              : validationMessages.first;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Center(child: HFLogo(height: 54)),
              const SizedBox(height: 18),
              const HFKicker('Start your journey'),
              const SizedBox(height: 7),
              const HFDisplayHeading(
                runs: [
                  HFHeadingRun('CREATE YOUR '),
                  HFHeadingRun.accent('ACCOUNT.'),
                ],
                fontSize: 34,
              ),
              const SizedBox(height: 8),
              const Text(
                "A few details and you're ready to find your fit with "
                'HelloFit.',
                style: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 11.5,
                  height: 1.7,
                  color: HFColors.muted,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: HFTextField(
                      label: 'First name',
                      controller: _first,
                      hint: 'First name',
                      enabled: !_busy,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.givenName],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: HFTextField(
                      label: 'Last name',
                      controller: _last,
                      hint: 'Last name',
                      enabled: !_busy,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.familyName],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              HFTextField(
                label: 'Email address',
                controller: _email,
                hint: 'name@example.com',
                enabled: !_busy,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 12),
              VerifiedMobileField(mobile: widget.mobile),
              const SizedBox(height: 14),
              TermsCheckline(
                value: _agreed,
                onChanged: _busy
                    ? null
                    : (v) => setState(() {
                          _agreed = v;
                          if (v) _error = null;
                        }),
              ),
              if (_error != null) ...[
                const SizedBox(height: HFSpacing.sm),
                FormErrorText(_error!),
              ],
              const SizedBox(height: 16),
              HFPrimaryButton(
                label: 'Create Account',
                busy: _busy,
                onPressed: _submit,
              ),
              const SizedBox(height: HFSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
