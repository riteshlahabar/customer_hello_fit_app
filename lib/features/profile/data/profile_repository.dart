import '../../../core/dates/hf_date.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';
import 'profile_models.dart';

/// §3.2 profile and §3.3 addresses.
///
/// Every write sends only the keys it was given: the backend's
/// `ValidationPipe` whitelists, and a `null` for an untouched field would be
/// rejected rather than ignored.
class ProfileRepository {
  ProfileRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<ApiResult<CustomerProfile>> profile() => _api.get(
        '/app/customer/profile',
        parse: (data) => CustomerProfile.fromJson(asMap(data)),
      );

  /// US-C04. The mobile is deliberately absent — it is the login identity and
  /// is changed only by verifying a new number.
  Future<ApiResult<CustomerProfile>> updateProfile({
    String? name,
    String? gender,
    String? email,
    DateTime? dob,
    String? goal,
    String? healthNotes,
    String? referredByCode,
  }) =>
      _api.patch(
        '/app/customer/profile',
        body: {
          'name': ?name,
          'gender': ?gender,
          'email': ?email,
          // `@IsISO8601` on the DTO, so the wire format — not the display one.
          if (dob != null) 'dob': HfDate.wire(dob),
          'goal': ?goal,
          'healthNotes': ?healthNotes,
          'referredByCode': ?referredByCode,
        },
        parse: (data) => CustomerProfile.fromJson(asMap(data)),
      );

  Future<ApiResult<List<Address>>> addresses() => _api.get(
        '/app/customer/addresses',
        parse: (data) => asMapList(data).map(Address.fromJson).toList(),
      );

  Future<ApiResult<Address>> address(String id) => _api.get(
        '/app/customer/addresses/$id',
        parse: (data) => Address.fromJson(asMap(data)),
      );

  /// US-C05. `areaId` and `cityId` are not sent: `address-geo.ts` resolves
  /// both from the pincode, and a changed pincode re-resolves them.
  Future<ApiResult<Address>> createAddress({
    required String label,
    required String line1,
    required String pincode,
    String? line2,
    String? landmark,
    String? accessNotes,
    double? lat,
    double? lng,
    bool? isDefault,
  }) =>
      _api.post(
        '/app/customer/addresses',
        body: {
          'label': label,
          'line1': line1,
          'pincode': pincode,
          'line2': ?line2,
          'landmark': ?landmark,
          'accessNotes': ?accessNotes,
          'lat': ?lat,
          'lng': ?lng,
          'isDefault': ?isDefault,
        },
        parse: (data) => Address.fromJson(asMap(data)),
      );

  Future<ApiResult<Address>> updateAddress(
    String id, {
    String? label,
    String? line1,
    String? line2,
    String? landmark,
    String? pincode,
    String? accessNotes,
    double? lat,
    double? lng,
  }) =>
      _api.patch(
        '/app/customer/addresses/$id',
        body: {
          'label': ?label,
          'line1': ?line1,
          'line2': ?line2,
          'landmark': ?landmark,
          'pincode': ?pincode,
          'accessNotes': ?accessNotes,
          'lat': ?lat,
          'lng': ?lng,
        },
        parse: (data) => Address.fromJson(asMap(data)),
      );

  /// Promotes one address and demotes the rest, in one transaction.
  Future<ApiResult<Address>> makeDefault(String id) => _api.post(
        '/app/customer/addresses/$id/default',
        parse: (data) => Address.fromJson(asMap(data)),
      );

  /// Soft delete. Refused with a 409 while a session is still scheduled
  /// there — the teacher is on the way to that door.
  Future<ApiResult<dynamic>> deleteAddress(String id) =>
      _api.delete<dynamic>('/app/customer/addresses/$id');
}
