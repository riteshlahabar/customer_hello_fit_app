import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../catalog/catalog_providers.dart';
import '../../catalog/data/catalog_models.dart';

/// Page 09's `.categories` — a four-up grid on a taupe panel.
///
/// The design hard-codes Strength / Yoga / Pilates / Fitness with a stock
/// photo each; the real tiles are `GET /categories` in the admin's
/// `sortOrder`, so the **first four live ones** are shown and "View all"
/// carries the rest. Each tile's art is the admin's `imageUrl`; a category
/// with none falls back to a tinted initial rather than a broken box.
class HomeCategories extends ConsumerWidget {
  const HomeCategories({super.key, required this.onSelect});

  /// Page 12 Service Categories is not built yet, so for now every tile and
  /// the "View all" link land in the same place.
  final ValueChanged<ServiceCategory> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(serviceCategoriesProvider);
    final rows = categories.value ?? const <ServiceCategory>[];

    // Nothing to show and nothing loading: the section head above it has
    // already been drawn by the screen, so an empty panel is still the
    // honest answer — but a zero-height one is not worth the padding.
    if (rows.isEmpty && !categories.isLoading) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: HFColors.panelFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HFColors.panelBorder),
      ),
      child: Row(
        children: [
          for (final category in rows.take(4))
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.5),
                child: _CategoryTile(
                  category: category,
                  onTap: () => onSelect(category),
                ),
              ),
            ),
          // Keeps the four columns the design's width when fewer than four
          // categories are live.
          for (var i = rows.take(4).length; i < 4; i++) const Spacer(),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final ServiceCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 6, 5, 8),
        decoration: BoxDecoration(
          color: HFColors.tileFill,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          children: [
            _Art(category: category),
            const SizedBox(height: 6),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: HFColors.captionInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `.cat-img` — a 66px square with the design's `#1616141c` wash over it.
class _Art extends StatelessWidget {
  const _Art({required this.category});

  final ServiceCategory category;

  @override
  Widget build(BuildContext context) {
    final url = category.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: SizedBox(
        height: 66,
        width: double.infinity,
        child: ColoredBox(
          color: HFColors.taupe,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (url != null && url.isNotEmpty)
                Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _Initial(name: category.name),
                )
              else
                _Initial(name: category.name),
              const ColoredBox(color: Color(0x1C161614)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HFColors.iconWash,
      alignment: Alignment.center,
      child: Text(
        name.isEmpty ? '?' : name[0].toUpperCase(),
        style: const TextStyle(
          fontFamily: HFFonts.display,
          fontSize: 24,
          color: HFColors.primary,
        ),
      ),
    );
  }
}
