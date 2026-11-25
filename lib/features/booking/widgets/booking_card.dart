import 'package:flutter/material.dart';

import '../../../app/widgets/pending_screen.dart';
import '../../../core/theme/tokens.dart';
import '../booking_status.dart';
import '../data/booking_detail_models.dart';
import 'booking_card_details.dart';
import 'booking_card_parts.dart';

/// Page 27's `.card` — one booking.
///
/// **Every action leads to an unbuilt design**: Details is page 29, and the
/// orange button is page 32, 23 or 53 depending on the chip. Each routes to a
/// stand-in naming its page rather than to a screen invented here; the
/// stand-ins go as those four land.
class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking});

  final BookingSummary booking;

  @override
  Widget build(BuildContext context) {
    final chip = bookingChipFor(booking);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: HFColors.listCardFill,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: HFColors.listCardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingCardTop(booking: booking, chip: chip),
            BookingCardTrainer(booking: booking),
            BookingCardDetails(session: booking.firstSession),
            _Bottom(booking: booking, chip: chip),
          ],
        ),
      ),
    );
  }
}

/// `.bottom` — the payable figure and the one or two actions.
class _Bottom extends StatelessWidget {
  const _Bottom({required this.booking, required this.chip});

  final BookingSummary booking;
  final BookingChip chip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '₹${booking.payable.round()}',
            style: const TextStyle(
              fontFamily: HFFonts.display,
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: HFColors.ink,
            ),
          ),
        ),
        _Action(
          label: 'Details',
          primary: false,
          onTap: () => PendingScreen.push(
            context,
            title: 'Booking ${booking.code}',
            designPage: 'Page 29 Booking Details',
          ),
        ),
        if (chip.actionLabel case final label?)
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: _Action(
              label: label,
              primary: true,
              onTap: () => PendingScreen.push(
                context,
                title: label,
                designPage: chip.actionDesignPage!,
              ),
            ),
          ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: primary ? HFColors.primary : HFColors.panelSoft,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: primary ? HFColors.primary : HFColors.actionBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: primary ? Colors.white : HFColors.actionInk,
          ),
        ),
      ),
    );
  }
}
