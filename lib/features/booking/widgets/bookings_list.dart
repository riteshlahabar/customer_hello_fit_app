import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../bookings_controller.dart';
import 'booking_card.dart';

/// `#bookingList` and the `.empty` panel under it.
///
/// Four states: the cards, the design's "No bookings in this category yet",
/// a spinner on first load, and — added, since the design has none and
/// US-C13 is a signed-in read that can genuinely fail — the backend's own
/// message with a retry.
class BookingsList extends ConsumerWidget {
  const BookingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(bookingsFilterProvider);
    final bookings = ref.watch(bookingsProvider(filter));

    return switch (bookings) {
      AsyncValue(:final value?) => value.isEmpty
          ? const _Panel(message: 'No bookings in this category yet.')
          : Column(
              children: [
                for (final booking in value) BookingCard(booking: booking),
              ],
            ),
      AsyncValue(:final error?) => _Panel(
          message: error.toString(),
          onRetry: () => ref.invalidate(bookingsProvider(filter)),
        ),
      _ => const Padding(
          padding: EdgeInsets.only(top: HFSpacing.xl),
          child: Center(child: CircularProgressIndicator(color: HFColors.primary)),
        ),
    };
  }
}

/// `.empty` — the design's panel, reused for the failure line because it is
/// the same shape with different copy.
class _Panel extends StatelessWidget {
  const _Panel({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 38),
      decoration: BoxDecoration(
        color: HFColors.panelSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: HFColors.cardLine),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: HFFonts.body,
              fontSize: 10,
              height: 1.6,
              color: HFColors.muted,
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text(
                'Try again',
                style: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: HFColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
