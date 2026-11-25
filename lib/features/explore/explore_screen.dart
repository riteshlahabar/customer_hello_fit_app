import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';
import '../catalog/catalog_providers.dart';
import '../favourites/saved_trainers_controller.dart';
import 'explore_controller.dart';
import 'widgets/explore_filter_chips.dart';
import 'widgets/explore_header.dart';
import 'widgets/explore_location_row.dart';
import 'widgets/explore_results.dart';
import 'widgets/explore_search_field.dart';
import 'widgets/explore_sort_row.dart';

/// Page 10, Search Trainers — the Explore tab.
///
/// The design's `.screen` scrolls its header away with the results, so there
/// is no AppBar; `CustomerShell` supplies the bottom nav and the ivory
/// ground. Sections in the design's order: header, search, location, filter
/// chips, sort row, results.
///
/// **This is the app's one search.** Page 09's search box hands off here
/// rather than querying, so there is a single `q` implementation.
///
/// Not reached from here: page 11 Search Filters, which is a sheet over this
/// screen and is unbuilt — page 10 draws no filter button of its own, only
/// the chip rail, so nothing is missing from this conversion.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: HFColors.primary,
        onRefresh: () async {
          ref.invalidate(serviceCategoriesProvider);
          ref.invalidate(savedTrainerIdsProvider);
          ref.invalidate(exploreResultsProvider);
          await ref.read(exploreResultsProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, HFSpacing.lg),
          children: const [
            ExploreHeader(),
            ExploreSearchField(),
            ExploreLocationRow(),
            ExploreFilterChips(),
            ExploreSortRow(),
            ExploreResults(),
          ],
        ),
      ),
    );
  }
}
