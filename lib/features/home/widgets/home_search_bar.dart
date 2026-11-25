import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// Page 09's `.search`.
///
/// It is a **tap target, not an input**: the design's own placeholder
/// ("Search trainers, workouts, yoga...") belongs to page 10, which owns the
/// query, the results and the filter sheet. Typing here would need a second
/// search implementation that page 10 then has to agree with, so the row
/// hands off instead. The `.filter` chip goes to the same place — page 11 is
/// a sheet over page 10, not a screen reachable from here.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Semantics(
        button: true,
        label: 'Search trainers and workouts',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: Container(
            height: 47,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: HFColors.searchFill,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: HFColors.searchBorder),
              boxShadow: const [
                BoxShadow(
                  color: HFColors.heroScrimFaint,
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 18, color: HFColors.softMuted),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'Search trainers, workouts, yoga...',
                    style: TextStyle(
                      fontFamily: HFFonts.body,
                      fontSize: 11,
                      color: HFColors.softMuted,
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: HFColors.iconWash,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    size: 17,
                    color: HFColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
