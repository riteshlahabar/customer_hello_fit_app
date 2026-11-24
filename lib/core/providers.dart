import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/auth_restore.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/billing/data/billing_repository.dart';
import '../features/booking/data/booking_repository.dart';
import '../features/catalog/data/catalog_repository.dart';
import '../features/favourites/data/favourite_repository.dart';
import '../features/notifications/data/notification_repository.dart';
import '../features/payment/data/payment_repository.dart';
import '../features/profile/data/profile_repository.dart';
import '../features/providers/data/provider_repository.dart';
import '../features/reviews/data/review_repository.dart';
import '../features/serviceability/data/serviceability_repository.dart';
import 'network/api_client.dart';
import 'storage/onboarding_store.dart';
import 'storage/token_store.dart';

/// Composition root. Everything is overridable in tests, which is why nothing
/// constructs its own dependencies.
///
/// One repository per PDF section 3 area, each a thin wrapper over the API
/// that already exists. **No screen state lives here** — controllers come with
/// the designs; these are the data layer and nothing else.
final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

/// Whether the onboarding slides have been seen. Separate from the token
/// store so signing out does not replay them.
final onboardingStoreProvider =
    Provider<OnboardingStore>((ref) => OnboardingStore());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(tokenStore: ref.watch(tokenStoreProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    api: ref.watch(apiClientProvider),
    tokenStore: ref.watch(tokenStoreProvider),
  );
});

/// §3.2 profile, §3.3 addresses.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(api: ref.watch(apiClientProvider));
});

/// Decides the first screen on launch and keeps a stored session alive, so a
/// signed-in customer is never asked for a second OTP.
final sessionRestorerProvider = Provider<SessionRestorer>((ref) {
  return SessionRestorer(
    tokens: ref.watch(tokenStoreProvider),
    onboarding: ref.watch(onboardingStoreProvider),
    profiles: ref.watch(profileRepositoryProvider),
  );
});

/// §3.4 categories, services, packages, add-ons.
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(api: ref.watch(apiClientProvider));
});

/// §3.4 search, §3.5 profiles.
final providerRepositoryProvider = Provider<ProviderRepository>((ref) {
  return ProviderRepository(api: ref.watch(apiClientProvider));
});

/// Saved trainers — client instruction, not in the PDF.
final favouriteRepositoryProvider = Provider<FavouriteRepository>((ref) {
  return FavouriteRepository(api: ref.watch(apiClientProvider));
});

/// Pincode coverage and the city/area masters.
final serviceabilityRepositoryProvider =
    Provider<ServiceabilityRepository>((ref) {
  return ServiceabilityRepository(api: ref.watch(apiClientProvider));
});

/// §3.6 booking, §3.8 history.
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(api: ref.watch(apiClientProvider));
});

/// §3.7 payment, the wallet and the coupon check.
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(api: ref.watch(apiClientProvider));
});

/// §3.8 invoices and refunds.
final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return BillingRepository(api: ref.watch(apiClientProvider));
});

/// §3.10 reviews.
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(api: ref.watch(apiClientProvider));
});

/// §3.9 in-app notifications and channel preferences.
final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepository(api: ref.watch(apiClientProvider));
});
