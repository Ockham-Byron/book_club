import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String? id;
  String? title;
  String? author;
  int? length;
  String? cover;
  Timestamp? dueDate;
  // String? ownerId;
  // String? lenderId;
  // List<String>? nbOfReaders;
  // List<String>? nbOfFavorites;

  BookModel(
      {this.id,
      this.title,
      this.author,
      this.length,
      this.dueDate,
      // this.ownerId,
      // this.lenderId,
      // this.nbOfReaders,
      // this.nbOfFavorites,
      this.cover =
          "https://cdn1.sosav.fr/es/store/69972-large_default/frame-interno-oficial-wiko-Lenny.jpg"});
}
