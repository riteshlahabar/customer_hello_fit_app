import '../../../core/dates/hf_date.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';

/// §3.9's in-app half: the bell, the badge and the channel switches.
///
/// Push arrives through Firebase against the device registered at OTP verify;
/// this is the stored copy of the same events, so the list is what the screen
/// renders and the push is only the tap-through.
class NotificationRepository {
  NotificationRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// The paged feed. `meta` carries `total` and `unread`, which is why the
  /// result is kept whole rather than reduced to a list.
  Future<ApiResult<List<AppNotification>>> list({
    bool unreadOnly = false,
    int? page,
    int? limit,
  }) =>
      _api.get(
        '/app/notifications',
        query: {
          if (unreadOnly) 'unreadOnly': true,
          'page': ?page,
          'limit': ?limit,
        },
        parse: (data) => asMapList(data).map(AppNotification.fromJson).toList(),
      );

  /// Just the badge.
  Future<ApiResult<int>> unreadCount() => _api.get(
        '/app/notifications/unread-count',
        parse: (data) => asInt(asMap(data)['unread']),
      );

  Future<ApiResult<Map<String, dynamic>>> markRead(String id) =>
      _api.post('/app/notifications/$id/read', parse: asMap);

  Future<ApiResult<Map<String, dynamic>>> markAllRead() =>
      _api.post('/app/notifications/read-all', parse: asMap);

  Future<ApiResult<NotificationPreferences>> preferences() => _api.get(
        '/app/notifications/preferences',
        parse: (data) => NotificationPreferences.fromJson(asMap(data)),
      );

  /// Turns one channel on or off, either for everything (`eventKey` null) or
  /// for a single event.
  ///
  /// **Only promotional events can actually be suppressed** — the backend
  /// stores the row either way, but a transactional event ignores it. A
  /// customer cannot opt out of being told their teacher is at the door.
  Future<ApiResult<Map<String, dynamic>>> setPreference({
    required String channel,
    required bool enabled,
    String? eventKey,
  }) =>
      _api.put(
        '/app/notifications/preferences',
        body: {
          'channel': channel,
          'enabled': enabled,
          'eventKey': ?eventKey,
        },
        parse: asMap,
      );
}

/// One stored in-app notification.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.eventKey,
    required this.title,
    required this.body,
    required this.data,
    this.deepLink,
    this.readAt,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: asString(json['id']),
        eventKey: asString(json['eventKey']),
        title: asString(json['title']),
        body: asString(json['body']),
        data: asMap(json['data']),
        deepLink: json['deepLink'] as String?,
        readAt: HfDate.parse(json['readAt']),
        createdAt: HfDate.parse(json['createdAt']),
      );

  final String id;

  /// `booking.confirmed`, `assignment.request_rejected`, … — the matrix key.
  /// Stable: the backend never renames one.
  final String eventKey;
  final String title;
  final String body;

  /// The placeholder values the copy was rendered from, kept so a screen can
  /// route on `bookingCode` without re-parsing the sentence.
  final Map<String, dynamic> data;

  /// Where tapping it should go, e.g. `/bookings/HF-2026-000123`.
  final String? deepLink;
  final DateTime? readAt;
  final DateTime? createdAt;

  bool get isUnread => readAt == null;
}

/// `GET /app/notifications/preferences`.
class NotificationPreferences {
  const NotificationPreferences({
    required this.defaultEnabled,
    required this.overrides,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      NotificationPreferences(
        defaultEnabled: asBool(json['defaultEnabled'], fallback: true),
        overrides: asMapList(json['overrides'])
            .map(
              (o) => (
                channel: asString(o['channel']),
                // `*` means every event on that channel.
                eventKey: asString(o['eventKey'], fallback: '*'),
                enabled: asBool(o['enabled']),
              ),
            )
            .toList(),
      );

  /// Everything is on unless an override says otherwise.
  final bool defaultEnabled;
  final List<({String channel, String eventKey, bool enabled})> overrides;
}
