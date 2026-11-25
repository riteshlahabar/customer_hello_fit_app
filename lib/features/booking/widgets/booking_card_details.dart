import 'package:flutter/material.dart';

import '../../../core/dates/hf_date.dart';
import '../../../core/theme/tokens.dart';
import '../data/booking_session_models.dart';

/// `.details` — the DATE and TIME cells between two hairlines.
///
/// **Dates are `dd-mm-yyyy`** (rule 4), not the design's "Wed, 11 Nov 2026".
/// A booking whose sessions have not been generated shows a dash rather than
/// today's date.
///
/// Page 28's design adds LOCATION and DURATION cells here; those belong to
/// that screen, and page 28 is this list's Upcoming tab rather than a screen
/// of its own, so the grid stays the two cells page 27 draws.
class BookingCardDetails extends StatelessWidget {
  const BookingCardDetails({super.key, required this.session});

  final BookingSessionRow? session;

  @override
  Widget build(BuildContext context) {
    final date = session?.sessionDate;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 13),
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: HFColors.cardLine),
          bottom: BorderSide(color: HFColors.cardLine),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Cell(
              label: 'DATE',
              value: date == null ? '--' : HfDate.format(date),
            ),
          ),
          Expanded(
            child: _Cell(label: 'TIME', value: session?.slotLabel ?? '--'),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 8,
            color: HFColors.muted,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: HFColors.ink,
          ),
        ),
      ],
    );
  }
}
