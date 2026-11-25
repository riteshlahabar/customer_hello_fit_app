import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// Page 40's `.edit` — the EDIT PROFILE button on the title row.
class ProfileEditButton extends StatelessWidget {
  const ProfileEditButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: HFColors.panelSoft,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HFColors.cardLine),
        ),
        child: const Text(
          'EDIT PROFILE',
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: HFColors.primary,
          ),
        ),
      ),
    );
  }
}
