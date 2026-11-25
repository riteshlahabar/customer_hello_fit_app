import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/hf_brand_header.dart';
import '../../core/widgets/hf_page_title.dart';
import 'saved_controller.dart';
import 'saved_trainers_controller.dart';
import 'widgets/saved_filter_chips.dart';
import 'widgets/saved_list.dart';
import 'widgets/saved_search_field.dart';

/// Page 43, Saved Trainers — the Saved tab.
///
/// **Not in the v3 PDF**: saved trainers are the client's instruction of
/// 13-11-2026, and `favourites/` was built for it. Everything on the screen
/// is `GET /favourites` plus local filtering — no new backend.
///
/// Sections in the design's order: brand bar, title block, search, filter
/// rail, cards. No AppBar, like every other tab: the design scrolls its own
/// header away with the content.
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: HFColors.primary,
        onRefresh: () async {
          // The ids first: the list watches them, so invalidating the ids
          // alone would refetch the cards and then refetch them again.
          ref.invalidate(savedTrainerIdsProvider);
          await ref.read(savedTrainersProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, HFSpacing.lg),
          children: const [
            HFBrandHeader(),
            HFPageTitle(
              eyebrow: 'YOUR FITNESS FAVOURITES',
              title: 'Saved Trainers',
              sub: 'Your go-to fitness experts, all in one place.',
              titleSize: 31,
            ),
            SavedSearchField(),
            SavedFilterChips(),
            SavedList(),
          ],
        ),
      ),
    );
  }
}
