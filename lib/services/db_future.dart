import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBFuture {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /* ---------------------------- */
  /* -- COLLECTIONS REFERENCE -- */
  /* -------------------------- */

  // Users collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  //Groups collection reference
  final CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection("groups");

  //Books collection reference
  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection("groups");

  /* ---------------------------- */
  /* ---------- USER ------------ */
  /* ---------------------------- */

  //Register UserData
  Future<String> createUser(UserModel user) async {
    String resultMessage = "error";
    // List<String> readBooks = [];
    // List<String> favoriteBooks = [];
    // List<String> dontWantToReadBooks = [];

    try {
      await usersCollection.doc(user.uid).set({
        "pseudo": user.pseudo!.trim(),
        "email": user.email!.trim(),
        "pictureUrl": user.pictureUrl!.trim()
        // "readBooks": readBooks,
        // "favoriteBooks": favoriteBooks,
        // "readPages": user.readPages,
        // "dontWantToReadBooks": dontWantToReadBooks
      });
      resultMessage = "success";
    } catch (e) {
      //
    }
    return resultMessage;
  }

  /* ---------------------------- */
  /* ---------- GROUP ----------- */
  /* ---------------------------- */

  Future<String> createGroup(
    String groupName,
    UserModel user,
  ) async {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(user.uid!);
      DocumentReference _docRef = await groupsCollection.add({
        "name": groupName.trim(),
        "leader": user.uid,
        "members": members,
        "currentBookId": null,
        "indexPickingBook": 0,
      });
      await usersCollection.doc(user.uid).update({
        "groupId": _docRef.id,
      });

      retVal = "success";
    } catch (e) {}

    return retVal;
  }

  /* ---------------------------- */
  /* ----------- BOOK ----------- */
  /* ---------------------------- */

  Future<String> addSingleBook(
      String groupId, BookModel book, int nextPicker) async {
    String message = "error";

    try {
      DocumentReference _docRef =
          await booksCollection.doc(groupId).collection("books").add({
        "title": book.title,
        "author": book.author,
        "length": book.length,
        "dueDate": book.dueDate,
        "cover": book.cover
      });

      //add book to the Group schedule
      await groupsCollection.doc(groupId).update({
        "currentBookId": _docRef.id,
        "currentBookDue": book.dueDate,
        "indexPickingBook": nextPicker,
        //"nbOfBooks": FieldValue.increment(1),
      });
      message = "success";
    } catch (e) {
      //
    }
    return message;
  }
}
