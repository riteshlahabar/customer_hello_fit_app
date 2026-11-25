import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../providers/data/provider_models.dart';
import 'saved_trainer_details.dart';

/// Page 43's `.card`.
///
/// **A third card shape, not page 10's.** The design insets a 76×85 rounded
/// photograph inside an 11px-padded `--soft` card; page 10's `.trainer-card`
/// runs a 112px photograph flush to the card edge and carries a `.verified`
/// badge and a `.meta` line, neither of which this design draws. So it is its
/// own widget rather than a flag on `ExploreTrainerTile`. (An older note in
/// `tokens.dart` claimed page 43 reused that card — it does not.)
class SavedTrainerCard extends StatelessWidget {
  const SavedTrainerCard({
    super.key,
    required this.trainer,
    required this.onUnsave,
    required this.onOpen,
  });

  final ProviderSummary trainer;

  /// The filled `.heart`. Every card here is saved by definition, so the
  /// heart only ever removes.
  final VoidCallback onUnsave;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.5),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: HFColors.panelSoft,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: HFColors.cardLine),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Photo(url: trainer.photoUrl),
              const SizedBox(width: 11),
              Expanded(
                child: SavedTrainerDetails(
                  trainer: trainer,
                  onUnsave: onUnsave,
                  onOpen: onOpen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `.photo`. No photo column stands behind `photoUrl` for most providers yet,
/// so the slot falls back to the taupe plate the rest of the app uses rather
/// than to a broken image.
class _Photo extends StatelessWidget {
  const _Photo({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: HFColors.taupe,
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 32, color: Colors.white),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 76,
        height: 85,
        child: url == null || url!.isEmpty
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}
