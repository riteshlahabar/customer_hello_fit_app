import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The five tabs of page 09's `.bottom-nav`, in the designed order.
///
/// These replace the Phase-1 list in `shells.dart`, whose fourth tab was
/// "Progress" — that pointed at the workout module (pages 34-39), which the
/// client ruled out of scope on 23-11-2026. The designs say Saved.
/// All five are built as of 24-11-2026 — pages 09, 10, 27, 43 and 40 — so the
/// `designPage` label each tab used to carry for `PendingTab` is gone with it.
enum CustomerTab {
  home('Home', Icons.home_outlined),
  explore('Explore', Icons.search),
  bookings('Bookings', Icons.calendar_today_outlined),
  saved('Saved', Icons.favorite_border),
  profile('Profile', Icons.person_outline);

  const CustomerTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Which tab is showing. A provider rather than a callback chain, because
/// page 09 switches tabs from five different places — the search box, the
/// hero button, both "View all" links and the header's profile button.
class CustomerTabController extends Notifier<CustomerTab> {
  @override
  CustomerTab build() => CustomerTab.home;

  void select(CustomerTab tab) => state = tab;
}

final customerTabProvider =
    NotifierProvider<CustomerTabController, CustomerTab>(
  CustomerTabController.new,
);
