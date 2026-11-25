import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// Page 09's `.promo` — "New to HelloFit? / Your first step starts here."
///
/// Fixed copy straight from the design, not a server-driven banner: there is
/// no promotions or CMS endpoint in the API and the PDF does not ask for one.
/// It is a second route into Explore, which is where its arrow points.
class HomePromo extends StatelessWidget {
  const HomePromo({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: HFColors.promoFill,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: HFColors.promoBorder),
          ),
          child: Row(
            children: [
              const Expanded(child: _Copy()),
              const SizedBox(width: HFSpacing.sm),
              Container(
                height: 42,
                width: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HFColors.primary,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.north_east,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Copy extends StatelessWidget {
  const _Copy();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NEW TO HELLOFIT?',
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: HFColors.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Your first step starts here.',
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: HFColors.ink,
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Find the right trainer for your goals.',
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 9.5,
            color: HFColors.muted,
          ),
        ),
      ],
    );
  }
}
