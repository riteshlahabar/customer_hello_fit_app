import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_result.dart';
import '../../core/providers.dart';
import 'data/profile_models.dart';

/// Carries the backend's own message to page 40's retry line.
class ProfileFailed implements Exception {
  const ProfileFailed(this.message);

  final String message;

  @override
  String toString() => message;
}

/// `GET /app/customer/profile` — shared by page 09's greeting and page 40.
///
/// It lived in `home_controller.dart` until page 40 landed; it sits here for
/// the same reason the categories and the address label do, which is that
/// `CustomerShell` keeps every tab alive and a copy per feature would fetch
/// the profile twice on every launch.
///
/// **It throws rather than failing soft to null**, which serves both callers:
/// page 09's greeting reads `.value` and so still drops to its generic half,
/// while page 40 — a screen that is nothing but this payload — can tell a
/// failure from a load and offer a retry.
final customerProfileProvider = FutureProvider<CustomerProfile>((ref) async {
  final result = await ref.watch(profileRepositoryProvider).profile();

  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiFailure(:final message) => throw ProfileFailed(message),
  };
});

/// "Area, City" from the default saved address — the `.location` line both
/// page 09 and page 10 draw.
///
/// Shared for the same reason the categories are: `CustomerShell` keeps every
/// tab alive, so a copy per feature would fetch the address book twice on
/// every launch.
///
/// Null when there is no address yet, or when the pincode is not mapped to a
/// service area; the row hides rather than inventing a city. **There is no
/// device-location permission in this app** and the PDF does not ask for one,
/// so "near you" always means the address the customer saved.
final defaultLocationLabelProvider = FutureProvider<String?>((ref) async {
  final result = await ref.watch(profileRepositoryProvider).addresses();

  if (result case ApiSuccess<List<Address>>(:final data) when data.isNotEmpty) {
    final address = data.firstWhere(
      (a) => a.isDefault,
      orElse: () => data.first,
    );
    final parts = [address.areaName, address.cityName]
        .where((p) => p != null && p.isNotEmpty)
        .join(', ');

    return parts.isEmpty ? null : parts;
  }

  return null;
});
