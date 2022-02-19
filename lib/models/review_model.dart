class ReviewModel {
  String? reviewId;
  int? rating;
  String? review;
  bool? favorite;

  ReviewModel({this.reviewId, this.rating, this.review, this.favorite = false});
}
