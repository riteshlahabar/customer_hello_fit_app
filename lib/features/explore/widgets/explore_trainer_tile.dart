import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../providers/data/provider_models.dart';
import 'explore_trainer_info.dart';

/// Page 10's `.trainer-card` — a 112px photograph beside the detail column.
///
/// A different card from page 09's rail tile (`TrainerCard`), which is narrow
/// and stacked; this is the list shape, and page 14 draws it too. **Page 43
/// does not**: that design insets a 76x85 photograph in an 11px-padded card
/// and drops the verified badge and the meta line, so it has its own widget.
///
/// **`.verified` is on every card.** `GET /providers` only returns publicly
/// visible providers — approved service, current KYC, not suspended — so the
/// badge is true by construction rather than a field; there is no
/// `verified` flag to read. **The design's "2.5 km away" is left out**:
/// `ProviderSummary` carries no distance and the endpoint computes none.
class ExploreTrainerTile extends StatelessWidget {
  const ExploreTrainerTile({
    super.key,
    required this.trainer,
    required this.saved,
    required this.onToggleSaved,
    required this.onOpen,
  });

  final ProviderSummary trainer;
  final bool saved;
  final VoidCallback onToggleSaved;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          clipBehavior: Clip.antiAlias,
          constraints: const BoxConstraints(minHeight: 137),
          decoration: BoxDecoration(
            color: HFColors.listCardFill,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: HFColors.listCardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 112, child: _Photo(trainer: trainer)),
              Expanded(
                child: ExploreTrainerInfo(
                  trainer: trainer,
                  saved: saved,
                  onToggleSaved: onToggleSaved,
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

/// `.photo` with its `.verified` badge.
class _Photo extends StatelessWidget {
  const _Photo({required this.trainer});

  final ProviderSummary trainer;

  @override
  Widget build(BuildContext context) {
    final url = trainer.photoUrl;
    final placeholder = Container(
      color: HFColors.taupe,
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 38, color: Colors.white),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (url == null || url.isEmpty)
          placeholder
        else
          Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => placeholder,
          ),
        const Positioned(left: 7, bottom: 7, child: _VerifiedBadge()),
      ],
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: HFColors.panelSoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        children: [
          Icon(Icons.check, size: 8, color: HFColors.verifiedInk),
          SizedBox(width: 2),
          Text(
            'Verified',
            style: TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 7,
              fontWeight: FontWeight.w700,
              color: HFColors.verifiedInk,
            ),
          ),
        ],
      ),
    );
  }
}
