import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

/// A pushed stand-in for a screen whose design is in hand but not converted.
///
/// The same device as [PendingTab], for a route rather than a tab: pages 10
/// and 27 both carry row actions that lead to unbuilt screens (15 Trainer
/// Profile, 29 Booking Details, 23 Payment Method, 53 Submit Review), and a
/// button that silently does nothing is worse than one that says what it is
/// waiting for. Inventing those screens is rule 2.
///
/// Delete each call site as its real screen lands.
class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key, required this.title, required this.designPage});

  /// What the action was called, so the customer sees the word they tapped.
  final String title;

  /// The supplied design this route is waiting on, e.g. `Page 15 Trainer
  /// Profile`.
  final String designPage;

  static void push(
    BuildContext context, {
    required String title,
    required String designPage,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PendingScreen(title: title, designPage: designPage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HFColors.ivory,
      appBar: AppBar(
        backgroundColor: HFColors.ivory,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: HFColors.ink,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(HFSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.pending_outlined,
                size: 34,
                color: HFColors.taupe,
              ),
              const SizedBox(height: HFSpacing.md),
              Text(
                '$designPage is next in the build order.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 11,
                  height: 1.6,
                  color: HFColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
