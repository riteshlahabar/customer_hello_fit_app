import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../booking_status.dart';
import '../data/booking_detail_models.dart';

/// `.top` — the booking reference and its status chip.
class BookingCardTop extends StatelessWidget {
  const BookingCardTop({super.key, required this.booking, required this.chip});

  final BookingSummary booking;
  final BookingChip chip;

  @override
  Widget build(BuildContext context) {
    final (wash, ink) = switch (chip) {
      BookingChip.confirmed ||
      BookingChip.completed => (HFColors.bookingOkWash, HFColors.bookingOkInk),
      BookingChip.pending => (
          HFColors.bookingPendingWash,
          HFColors.bookingPendingInk,
        ),
      BookingChip.cancelled => (
          HFColors.bookingCancelWash,
          HFColors.bookingCancelInk,
        ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'BOOKING ID · ${booking.code}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 9,
                color: HFColors.muted,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: wash,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              chip.label,
              style: TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `.trainer` — the provider's photograph, name and the service on the right.
class BookingCardTrainer extends StatelessWidget {
  const BookingCardTrainer({super.key, required this.booking});

  final BookingSummary booking;

  @override
  Widget build(BuildContext context) {
    final session = booking.firstSession;
    final url = session?.instructorPhotoUrl;
    final placeholder = Container(
      color: HFColors.taupe,
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 24, color: Colors.white),
    );

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 48,
            width: 48,
            child: url == null || url.isEmpty
                ? placeholder
                : Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => placeholder,
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // §4.7: the customer picks a provider and the provider then
                // accepts. Until that happens there is no name to show, and
                // the design has no such state.
                session?.instructorName ?? 'Awaiting provider',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: HFColors.ink,
                ),
              ),
              Text(
                bookingSubtitle(booking),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 9,
                  color: HFColors.muted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: HFSpacing.sm),
        SizedBox(
          width: 74,
          child: Text(
            booking.serviceName,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 9,
              height: 1.3,
              color: HFColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}

