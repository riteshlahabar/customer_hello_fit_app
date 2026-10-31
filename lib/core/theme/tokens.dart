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

/// Spec 5.9 names Anton for display headings and Poppins 300-800 for UI text.
/// The font files are not in the repo yet, so these family names resolve to
/// the platform default until the assets are added to pubspec.yaml.
abstract final class HFFonts {
  static const display = 'Anton';
  static const body = 'Poppins';
}
