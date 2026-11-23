import '../../../core/dates/hf_date.dart';
import '../../../core/network/json.dart';

/// `GET /instructors/:id/reviews` — the published half of a provider profile.
///
/// Reviews are double-blind: nothing appears here until the window closes, so
/// an empty list on a new provider is normal rather than an error.
class ProviderReviews {
  const ProviderReviews({required this.aggregate, required this.reviews});

  factory ProviderReviews.fromJson(Map<String, dynamic> json) =>
      ProviderReviews(
        aggregate: ReviewAggregate.fromJson(asMap(json['aggregate'])),
        reviews:
            asMapList(json['reviews']).map(PublishedReview.fromJson).toList(),
      );

  /// Always present: the backend substitutes a zeroed aggregate for a provider
  /// nobody has reviewed, so the card never has to branch on null.
  final ReviewAggregate aggregate;
  final List<PublishedReview> reviews;
}

class ReviewAggregate {
  const ReviewAggregate({
    required this.ratingAvg,
    required this.ratingCount,
    required this.criteriaAverages,
    required this.distribution,
  });

  factory ReviewAggregate.fromJson(Map<String, dynamic> json) =>
      ReviewAggregate(
        ratingAvg: asDouble(json['ratingAvg']),
        ratingCount: asInt(json['ratingCount']),
        criteriaAverages: asMap(json['criteriaAverages'])
            .map((key, value) => MapEntry(key, asDouble(value))),
        distribution: asMap(json['distribution'])
            .map((key, value) => MapEntry(asInt(key), asInt(value))),
      );

  final double ratingAvg;
  final int ratingCount;

  /// Keyed by criterion slug — `punctuality`, `knowledge`, …
  final Map<String, double> criteriaAverages;

  /// Stars 1–5 to how many reviews gave them.
  final Map<int, int> distribution;
}

class PublishedReview {
  const PublishedReview({
    required this.id,
    required this.overallRating,
    required this.tags,
    required this.photos,
    required this.criteriaScores,
    this.comment,
    this.recommendAgain,
    this.publishedAt,
    this.reply,
    this.repliedAt,
  });

  factory PublishedReview.fromJson(Map<String, dynamic> json) =>
      PublishedReview(
        id: asString(json['id']),
        overallRating: asDouble(json['overallRating']),
        tags: asStringList(json['tags']),
        photos: asStringList(json['photos']),
        criteriaScores: asMapList(json['criteriaScores'])
            .map(
              (c) => (
                slug: asString(asMap(c['criteria'])['slug']),
                name: asString(asMap(c['criteria'])['name']),
                score: asDouble(c['score']),
              ),
            )
            .toList(),
        comment: json['comment'] as String?,
        recommendAgain: json['recommendAgain'] as bool?,
        publishedAt: HfDate.parse(json['publishedAt']),
        reply: json['reply'] as String?,
        repliedAt: HfDate.parse(json['repliedAt']),
      );

  final String id;
  final double overallRating;
  final List<String> tags;
  final List<String> photos;

  /// Per-criterion stars, when the reviewer scored them.
  final List<({String slug, String name, double score})> criteriaScores;
  final String? comment;
  final bool? recommendAgain;
  final DateTime? publishedAt;

  /// The provider's single reply, if they wrote one.
  final String? reply;
  final DateTime? repliedAt;

  /// Reviews are published anonymously on a profile — there is no author name
  /// in the payload, and the app must not invent one.
  bool get hasReply => reply != null && reply!.isNotEmpty;
}
