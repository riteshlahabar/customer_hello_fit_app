import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/text/initials.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/hf_display_heading.dart';
import '../../profile/profile_providers.dart';

/// Page 09's `.greeting` and `.location`.
///
/// The design puts a photograph in the avatar slot. **`CustomerProfile` has
/// no photo field** — §3.2's payload is name, gender, mobile, email, dob,
/// goal and health notes, and there is no customer upload route — so the
/// circle is drawn with initials. Owed to the client alongside pages 05/07.
class HomeGreeting extends ConsumerWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(customerProfileProvider).value;
    final location = ref.watch(defaultLocationLabelProvider).value;
    final firstName = profile?.name.trim().split(RegExp(r'\s+')).first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // The design's "Good morning," with the name appended
                      // once it is known, which is the only part of this
                      // line that is not already in the design.
                      firstName == null || firstName.isEmpty
                          ? '${_partOfDay()},'
                          : '${_partOfDay()}, $firstName',
                      style: const TextStyle(
                        fontFamily: HFFonts.body,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: HFColors.muted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const HFDisplayHeading(
                      runs: [
                        HFHeadingRun("LET'S GET "),
                        HFHeadingRun.accent('FIT.'),
                      ],
                      fontSize: 28,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: HFSpacing.sm),
              _Avatar(name: profile?.name),
            ],
          ),
        ),
        if (location != null) _LocationRow(location),
      ],
    );
  }

  /// `.hello small`. The design shows the morning case; the other two are the
  /// same line at a different hour, not a new element.
  static String _partOfDay() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    // Page 40's avatar wants the same two letters, so the rule is shared.
    final initials = hfInitials(name);

    return Container(
      height: 42,
      width: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: HFColors.iconWash,
        shape: BoxShape.circle,
        border: Border.all(color: HFColors.checkWash, width: 2),
      ),
      child: initials.isEmpty
          ? const Icon(Icons.person_outline, size: 20, color: HFColors.primary)
          : Text(
              initials,
              style: const TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: HFColors.primary,
              ),
            ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow(this.location);

  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 14,
            color: HFColors.primary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 10,
                  color: HFColors.muted,
                ),
                children: [
                  const TextSpan(text: 'Training near '),
                  TextSpan(
                    text: location,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: HFColors.locationInk,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
