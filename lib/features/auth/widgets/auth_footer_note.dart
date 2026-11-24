import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// The grey legal line the auth screens close with (`.terms`, `.note`).
///
/// Terms of Service and Privacy Policy are named but not linked: §5.3 puts
/// those pages on the website, not in the app, and a dead link is worse than
/// plain text. Wire them up when the client supplies the URLs.
class AuthFooterNote extends StatelessWidget {
  const AuthFooterNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: HFFonts.body,
        fontSize: 9,
        height: 1.7,
        color: HFColors.faintMuted,
      ),
    );
  }
}
