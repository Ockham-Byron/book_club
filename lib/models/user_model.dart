class UserModel {
  String? uid;
  String? email;
  String? pseudo;
  String? pictureUrl;
  String? groupId;
  List<String>? readBooks;

  UserModel(
      {this.uid,
      this.pseudo,
      this.email,
      this.pictureUrl,
      this.groupId,
      this.readBooks});
}
