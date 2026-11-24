import '../../../core/theme/tokens.dart';
import '../../../core/widgets/hf_display_heading.dart';

/// One onboarding slide, transcribed from pages 02, 03 and 04.
///
/// The three pages share a frame — photograph, logo, Skip, ivory card, dots,
/// orange button — and differ only in this content, so they are one
/// `PageView` rather than three screens. The copy is the client's, word for
/// word; nothing here is written by us.
class OnboardingSlide {
  const OnboardingSlide({
    required this.image,
    required this.kicker,
    required this.heading,
    required this.description,
    required this.buttonLabel,
    required this.items,
    this.photoTag,
    this.itemsAreTiles = true,
  });

  final String image;
  final String kicker;
  final List<HFHeadingRun> heading;
  final String description;
  final String buttonLabel;

  /// The uppercase line over the photograph on pages 03 and 04.
  final String? photoTag;

  /// The three boxes above the dots — ticks on page 02, symbol tiles on 03
  /// and 04.
  final List<OnboardingItem> items;
  final bool itemsAreTiles;
}

class OnboardingItem {
  const OnboardingItem({required this.label, this.symbol});

  final String label;

  /// Null on page 02, where the items are tick chips rather than tiles.
  final String? symbol;
}

const onboardingSlides = <OnboardingSlide>[
  OnboardingSlide(
    image: HFAssets.onboardingHero1,
    kicker: 'Your fitness journey starts here',
    heading: [
      HFHeadingRun('STRONGER\nSTARTS '),
      HFHeadingRun.accent('WITH YOU.'),
    ],
    description:
        'Personal training that works around your life. Choose your goal, '
        'meet your trainer, and make every session count.',
    buttonLabel: 'Get Started',
    itemsAreTiles: false,
    items: [
      OnboardingItem(label: 'Personal trainers'),
      OnboardingItem(label: 'Flexible sessions'),
    ],
  ),
  OnboardingSlide(
    image: HFAssets.onboardingHero2,
    photoTag: 'Find your rhythm. Find your strength.',
    kicker: '02 / 03  •  Find your fitness',
    heading: [
      HFHeadingRun('YOUR GOAL.\n'),
      HFHeadingRun.accent('YOUR KIND'),
      HFHeadingRun(' OF FIT.'),
    ],
    description:
        'From strength training to yoga, discover workouts that match your '
        'goals and the way you love to move.',
    buttonLabel: 'Continue',
    items: [
      OnboardingItem(symbol: '✦', label: 'Strength'),
      OnboardingItem(symbol: '◉', label: 'Yoga'),
      OnboardingItem(symbol: '↗', label: 'Mobility'),
    ],
  ),
  OnboardingSlide(
    image: HFAssets.onboardingHero3,
    photoTag: 'Your place. Your pace. Your progress.',
    kicker: '03 / 03  •  Train anywhere',
    heading: [
      HFHeadingRun('YOUR SPACE.\n'),
      HFHeadingRun.accent('YOUR RULES.'),
    ],
    description:
        'At home, outdoors or online — connect with a trainer and make '
        'fitness fit your everyday life.',
    buttonLabel: 'Get Started',
    items: [
      OnboardingItem(symbol: '⌂', label: 'At Home'),
      OnboardingItem(symbol: '◎', label: 'Outdoor'),
      OnboardingItem(symbol: '▣', label: 'Online'),
    ],
  ),
];
