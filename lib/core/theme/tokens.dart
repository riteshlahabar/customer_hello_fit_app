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

  // --- Page 09, the home dashboard. One name per value in the design's
  // stylesheet; the ivory ground above is the same `--ivory`. ---

  /// `.search` ground and its outline.
  static const searchFill = Color(0xFFF3EAE0);
  static const searchBorder = Color(0xFFE8DCCF);

  /// `.round` — the header's circular bell and profile buttons.
  static const roundBorder = Color(0xFFEEE8E2);

  /// `.location b`, the city the customer trains in.
  static const locationInk = Color(0xFF39332E);

  /// `.categories` panel, and the `.cat` tile sitting inside it.
  static const panelFill = Color(0xFFF2E9DF);
  static const panelBorder = Color(0xFFE9DED2);
  static const tileFill = Color(0xFFFFF9F2);

  /// `.cat span` — the caption under a category tile.
  static const captionInk = Color(0xFF48423D);

  /// `.promo`.
  static const promoFill = Color(0xFFEDE2D6);
  static const promoBorder = Color(0xFFE3D5C7);

  /// `.trainer` — the card in a horizontal rail.
  static const cardFill = Color(0xFFF7EFE6);
  static const cardBorder = Color(0xFFE7DCCE);

  /// `.rating` star.
  static const ratingStar = Color(0xFFE49A23);

  /// `.bottom-nav`: an item at rest, and the bar's top hairline.
  static const navInactive = Color(0xFF96908A);
  static const navBorder = Color(0xFFEEE9E4);

  /// `.hero` — the three stops of the left-to-right scrim over the hero
  /// photograph, and the two copy colours on top of it.
  static const heroScrimStrong = Color(0xDC161614);
  static const heroScrimMid = Color(0x83161614);
  static const heroScrimFaint = Color(0x08161614);
  static const heroKicker = Color(0xFFFFD3CA);
  static const heroBody = Color(0xFFF5EEE9);

  // --- Page 10, search trainers. The wide result card and its chip rail;
  // page 14 Trainer Listing draws the same card. ---

  /// `.search` at rest, and the tinted square its magnifier sits in.
  static const searchOutline = Color(0xFFD9C8B7);
  static const searchIconWash = Color(0xFFF4E4D8);

  /// `.clear` — the round × inside the input.
  static const clearWash = Color(0xFFEFE5DA);

  /// `.filters` rail, and a `.chip` at rest on top of it.
  static const filterPanel = Color(0xFFF1E8DE);
  static const chipBorder = Color(0xFFE5D9CC);
  static const chipInk = Color(0xFF625B54);

  /// `.trainer-card` in a vertical list — deeper than the rail's [cardFill].
  /// Page 14 Trainer Listing draws this card; **page 43 does not** — its
  /// design is a third shape, an inset photograph on a `--soft` card.
  static const listCardFill = Color(0xFFF8F0E7);
  static const listCardBorder = Color(0xFFE8DCCE);

  /// `.verified` — the badge over a result photograph.
  static const verifiedInk = Color(0xFF24845A);

  /// `.view` — the card's "View Profile" button.
  static const viewWash = Color(0xFFF1DDD2);

  // --- Page 27, my bookings. ---

  /// `.tabs` track and the `.tab.active` / `.count` / `.empty` ground.
  static const tabTrack = searchFill;
  static const panelSoft = tileFill;

  /// `--line`, the hairline round a count tile and under the header.
  static const cardLine = Color(0xFFE8DDD1);

  /// `.status` and its two variants — a booking's own state, not spec 5.9's
  /// chips, which are the admin panel's.
  static const bookingOkWash = Color(0xFFE4EFE5);
  static const bookingOkInk = Color(0xFF39815E);
  static const bookingPendingWash = Color(0xFFF8EBD5);
  static const bookingPendingInk = Color(0xFFA36B17);
  static const bookingCancelWash = Color(0xFFF6E5DF);
  static const bookingCancelInk = Color(0xFFB34C38);

  /// `.actions button` — the secondary action beside the orange one.
  static const actionBorder = Color(0xFFDFCFC0);
  static const actionInk = Color(0xFF63594F);

  // --- Page 43, saved trainers, and page 40, my profile. Both reuse page
  // 27's `--beige` / `--soft` / `--line`; these two are their own. ---

  /// Page 43's `.rating` — an amber-brown, not page 09's [ratingStar].
  static const savedRatingInk = Color(0xFF9B6A20);

  /// Page 40's `.verified` line under the customer's name.
  static const memberVerifiedInk = Color(0xFF54704A);
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
