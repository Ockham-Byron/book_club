import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String? id;
  String? title;
  String? author;
  int? length;
  String? cover;
  Timestamp? dueDate;
  String? submittedBy;
  String? ownerId;
  String? lenderId;
  bool isLendable;
  List<String>? waitingList;

  // List<String>? nbOfReaders;
  // List<String>? nbOfFavorites;

  BookModel(
      {this.id,
      this.title,
      this.author,
      this.length,
      this.dueDate,
      this.submittedBy,
      this.ownerId,
      this.lenderId,
      this.isLendable = true,
      this.waitingList,
      // this.nbOfReaders,
      // this.nbOfFavorites,
      this.cover =
          "https://cdn1.sosav.fr/es/store/69972-large_default/frame-interno-oficial-wiko-Lenny.jpg"});
}
