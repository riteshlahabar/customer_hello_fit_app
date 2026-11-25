import 'package:flutter/material.dart';

import '../../../core/widgets/hf_brand_header.dart';
import '../../../core/widgets/hf_page_title.dart';

/// Page 27's `header` and the `.eyebrow` / `h1` / `.sub` block under it.
///
/// Both halves are now shared: pages 40 and 43 draw the same brand bar and
/// the same title block, so they live in `core/widgets/` and this file is
/// only page 27's copy.
class BookingsHeader extends StatelessWidget {
  const BookingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HFBrandHeader(),
        HFPageTitle(
          eyebrow: 'YOUR FITNESS JOURNEY',
          title: 'My Bookings',
          sub: 'Manage your sessions and keep your fitness plans on track.',
        ),
        SizedBox(height: 2),
      ],
    );
  }
}
