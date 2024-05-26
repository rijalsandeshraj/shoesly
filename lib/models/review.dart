class Review {
  final String reviewer;
  final String profileUrl;
  final num rating;
  final String review;
  final String reviewedDate;

  Review({
    required this.reviewer,
    required this.profileUrl,
    required this.rating,
    required this.review,
    required this.reviewedDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewer: json['reviewer'],
      profileUrl: json['profileUrl'],
      rating: json['rating'],
      review: json['review'],
      reviewedDate: json['reviewedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewer': reviewer,
      'profileUrl': profileUrl,
      'rating': rating,
      'review': review,
      'reviewedDate': reviewedDate,
    };
  }
}
