class UserModel {
  String? uid;
  String? email;
  String? pseudo;
  String? pictureUrl;
  String? groupId;
  List<String>? readBooks;
  List<String>? favoriteBooks;
  List<String>? dontWantToReadBooks;

  UserModel(
      {this.uid,
      this.pseudo,
      this.email,
      this.pictureUrl,
      this.groupId,
      this.readBooks,
      this.favoriteBooks,
      this.dontWantToReadBooks});
}
