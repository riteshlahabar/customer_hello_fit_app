import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/json.dart';
import 'review_models.dart';

/// §3.10 ratings and reviews, customer side.
///
/// Reviews are **double-blind**: what the customer writes is invisible to the
/// provider until the window closes or both sides have written. The app must
/// not show a submitted review as public — [ReviewSubmission] says which.
class ReviewRepository {
  ReviewRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// The criteria this direction scores, in `sortOrder`.
  Future<ApiResult<List<ReviewCriterion>>> criteria() => _api.get(
        '/app/customer/reviews/criteria',
        parse: (data) => asMapList(data).map(ReviewCriterion.fromJson).toList(),
      );

  /// US-C15 — completed sessions still waiting on a review.
  Future<ApiResult<List<PendingReview>>> pending() => _api.get(
        '/app/customer/reviews/pending',
        parse: (data) => asMapList(data).map(PendingReview.fromJson).toList(),
      );

  /// `criteriaScores` is keyed by criterion **slug**, 1–5 each.
  Future<ApiResult<ReviewSubmission>> submit({
    required String sessionId,
    required int overallRating,
    String? comment,
    List<String> tags = const [],
    List<String> photos = const [],
    bool? recommendAgain,
    Map<String, int> criteriaScores = const {},
  }) =>
      _api.post(
        '/app/customer/reviews',
        body: {
          'sessionId': sessionId,
          'overallRating': overallRating,
          'comment': ?comment,
          if (tags.isNotEmpty) 'tags': tags,
          if (photos.isNotEmpty) 'photos': photos,
          'recommendAgain': ?recommendAgain,
          if (criteriaScores.isNotEmpty)
            'criteria': criteriaScores.entries
                .map((e) => {'slug': e.key, 'score': e.value})
                .toList(),
        },
        parse: (data) => ReviewSubmission.fromJson(asMap(data)),
      );

  /// Allowed until `editLockedAt`. The criteria scores cannot be changed —
  /// only the rating, the words and the tags.
  Future<ApiResult<Map<String, dynamic>>> edit(
    String reviewId, {
    int? overallRating,
    String? comment,
    List<String>? tags,
    bool? recommendAgain,
  }) =>
      _api.patch(
        '/app/customer/reviews/$reviewId',
        body: {
          'overallRating': ?overallRating,
          'comment': ?comment,
          'tags': ?tags,
          'recommendAgain': ?recommendAgain,
        },
        parse: asMap,
      );

  /// My reviews and the replies to them.
  Future<ApiResult<List<MyReview>>> mine() => _api.get(
        '/app/customer/reviews/mine',
        parse: (data) => asMapList(data).map(MyReview.fromJson).toList(),
      );

  /// Reports someone else's review for moderation.
  Future<ApiResult<Map<String, dynamic>>> report(
    String reviewId, {
    required String reason,
  }) =>
      _api.post(
        '/app/customer/reviews/$reviewId/report',
        body: {'reason': reason},
        parse: asMap,
      );
}
