import '../../../core/dates/hf_date.dart';
import '../../../core/network/json.dart';

/// One scorable criterion (`GET /app/customer/reviews/criteria`).
///
/// Ten are seeded. A mandatory one must be scored for the submit to pass, so
/// the form has to render them all rather than a fixed list of its own.
class ReviewCriterion {
  const ReviewCriterion({
    required this.id,
    required this.name,
    required this.slug,
    required this.isMandatory,
    required this.sortOrder,
  });

  factory ReviewCriterion.fromJson(Map<String, dynamic> json) =>
      ReviewCriterion(
        id: asString(json['id']),
        name: asString(json['name']),
        slug: asString(json['slug']),
        isMandatory: asBool(json['isMandatory']),
        sortOrder: asInt(json['sortOrder']),
      );

  final String id;
  final String name;

  /// What a score is submitted under — the slug, not the id.
  final String slug;
  final bool isMandatory;
  final int sortOrder;
}

/// A completed session still awaiting this customer's review (US-C15).
///
/// The window is `review.windowDays` wide; once it closes the session drops
/// off this list and the reviews that did arrive are published.
class PendingReview {
  const PendingReview({
    required this.sessionId,
    required this.bookingId,
    required this.bookingCode,
    required this.serviceName,
    required this.fromMinute,
    this.sessionDate,
    this.completedAt,
    this.instructorId,
    this.instructorName,
    this.instructorPhotoUrl,
  });

  factory PendingReview.fromJson(Map<String, dynamic> json) {
    final booking = asMap(json['booking']);
    final instructor = asMap(json['instructor']);

    return PendingReview(
      sessionId: asString(json['id']),
      bookingId: asString(booking['id']),
      bookingCode: asString(booking['code']),
      serviceName: asString(asMap(json['service'])['name']),
      fromMinute: asInt(json['fromMinute']),
      sessionDate: HfDate.parse(json['sessionDate']),
      completedAt: HfDate.parse(json['completedAt']),
      instructorId: instructor['id'] as String?,
      instructorName: instructor['name'] as String?,
      instructorPhotoUrl: instructor['photoUrl'] as String?,
    );
  }

  final String sessionId;
  final String bookingId;
  final String bookingCode;
  final String serviceName;
  final int fromMinute;
  final DateTime? sessionDate;
  final DateTime? completedAt;
  final String? instructorId;
  final String? instructorName;
  final String? instructorPhotoUrl;
}

/// A review this customer wrote (`GET /app/customer/reviews/mine`).
class MyReview {
  const MyReview({
    required this.id,
    required this.overallRating,
    required this.tags,
    required this.state,
    required this.serviceName,
    this.comment,
    this.sessionDate,
    this.instructorName,
    this.instructorPhotoUrl,
    this.publishedAt,
    this.editLockedAt,
    this.reply,
    this.repliedAt,
  });

  factory MyReview.fromJson(Map<String, dynamic> json) {
    final session = asMap(json['session']);
    final instructor = asMap(session['instructor']);

    return MyReview(
      id: asString(json['id']),
      overallRating: asDouble(json['overallRating']),
      tags: asStringList(json['tags']),
      state: asString(json['state'], fallback: 'PENDING'),
      serviceName: asString(asMap(session['service'])['name']),
      comment: json['comment'] as String?,
      sessionDate: HfDate.parse(session['sessionDate']),
      instructorName: instructor['name'] as String?,
      instructorPhotoUrl: instructor['photoUrl'] as String?,
      publishedAt: HfDate.parse(json['publishedAt']),
      editLockedAt: HfDate.parse(json['editLockedAt']),
      reply: json['reply'] as String?,
      repliedAt: HfDate.parse(json['repliedAt']),
    );
  }

  final String id;
  final double overallRating;
  final List<String> tags;

  /// PENDING, PUBLISHED, FLAGGED or HIDDEN.
  final String state;
  final String serviceName;
  final String? comment;
  final DateTime? sessionDate;
  final String? instructorName;
  final String? instructorPhotoUrl;

  /// Null until the double-blind window closes.
  final DateTime? publishedAt;

  /// After this instant the review can no longer be edited.
  final DateTime? editLockedAt;
  final String? reply;
  final DateTime? repliedAt;

  bool get isPublished => state == 'PUBLISHED';
  bool get isEditable => editLockedAt == null ||
      DateTime.now().isBefore(editLockedAt!);
}

/// What a submit answers with. `flagged` means a moderator will look first —
/// the screen says so instead of claiming it is live.
class ReviewSubmission {
  const ReviewSubmission({
    required this.id,
    required this.state,
    required this.flagged,
    required this.flagReasons,
    required this.visibleToCounterparty,
    this.editableUntil,
  });

  factory ReviewSubmission.fromJson(Map<String, dynamic> json) =>
      ReviewSubmission(
        id: asString(json['id']),
        state: asString(json['state'], fallback: 'PENDING'),
        flagged: asBool(json['flagged']),
        flagReasons: asStringList(json['flagReasons']),
        visibleToCounterparty: asBool(json['visibleToCounterparty']),
        editableUntil: HfDate.parse(json['editableUntil']),
      );

  final String id;
  final String state;
  final bool flagged;

  /// Why it was auto-flagged, when it was.
  final List<String> flagReasons;

  /// True only when the other side had already reviewed, which closes the
  /// double-blind window and publishes both at once.
  final bool visibleToCounterparty;
  final DateTime? editableUntil;
}
