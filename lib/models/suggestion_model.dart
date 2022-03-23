class SuggestionModel {
  String? id;
  String? userId;
  int? votes;
  String? suggestion;
  bool? isWorkedByDev;
  bool? isAnonymous;

  SuggestionModel(
      {this.id,
      this.userId,
      this.suggestion,
      this.votes,
      this.isWorkedByDev,
      this.isAnonymous});
}
