import 'package:flutter/material.dart';

/// Design tokens transcribed from the HelloFit reference prototype (spec 5.9
/// and 6.4), shared by the app, admin panel and website.
///
/// These are the client's documented values, not invented styling. When the
/// final designs arrive they override this file.
abstract final class HFColors {
  static const primary = Color(0xFFE33E29);
  static const ivory = Color(0xFFFFF6EC);
  static const ink = Color(0xFF161614);
  static const muted = Color(0xFF77736D);
  static const hairline = Color(0xFFEEE4DA);
  static const success = Color(0xFF237A55);
  static const pageBackground = Color(0xFFFCFAF7);

  /// Status chip colours (spec 5.9).
  static const statusNeutral = ivory;
  static const statusActive = primary;
  static const statusComplete = success;
  static const statusCancelled = Color(0xFFFDECEA);
  static const statusPending = Color(0xFFFFF4D6);

  // --- Values read off the client's supplied HTML screens. Each one is in
  // the designs; none is invented. ---

  /// `--taupe`, declared on every screen from page 02 onwards.
  static const taupe = Color(0xFFC1B19E);

  /// The splash screen's near-black ground (page 01 `body`).
  static const splashBackground = Color(0xFF090909);

  /// Input outline at rest (`.field` border).
  static const fieldBorder = Color(0xFFE8E3DE);

  /// Body copy inside a card (`.desc`); lighter than [muted].
  static const bodyMuted = Color(0xFF6C655D);

  /// Field labels and feature captions (`.field-label`, `.feature`).
  static const labelInk = Color(0xFF37332F);

  /// Secondary lines — hints, "or", placeholder text.
  static const softMuted = Color(0xFF8A827B);
  static const faintMuted = Color(0xFFAAAAAA);

  /// Inactive page dot (`.dots i`).
  static const dotInactive = Color(0xFFD9CEC3);

  /// Tinted wash behind a feature tick (`.check`) and the OTP page's icon
  /// panel (`.icon-wrap`).
  static const checkWash = Color(0xFFF5D8D1);
  static const iconWash = Color(0xFFFFF0ED);
}

abstract final class HFRadius {
  /// Cards and modals.
  static const card = 22.0;

  /// Buttons and inputs.
  static const control = 12.0;
}

abstract final class HFSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class HFShadows {
  static const card = <BoxShadow>[
    BoxShadow(
      color: Color(0x122C1F14),
      blurRadius: 38,
      offset: Offset(0, 14),
    ),
  ];
}

/// Spec 5.9 names Anton for display headings and Poppins for UI text. Both
/// are bundled under `assets/fonts/` and registered in `pubspec.yaml`; Anton
/// ships in one weight only, so never ask it for a bold.
abstract final class HFFonts {
  static const display = 'Anton';
  static const body = 'Poppins';
}

/// The client's brand artwork, lifted from the supplied HTML screens.
abstract final class HFAssets {
  static const logo = 'assets/brand/hellofit_logo.png';

  /// Onboarding heroes, in slide order (pages 02, 03, 04). Named one by
  /// one rather than indexed out of a list, so the slide table stays const.
  static const onboardingHero1 = 'assets/onboarding/slide1.jpg';
  static const onboardingHero2 = 'assets/onboarding/slide2.jpg';
  static const onboardingHero3 = 'assets/onboarding/slide3.jpg';
}
