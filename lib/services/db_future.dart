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
        "pictureUrl": user.pictureUrl!.trim(),
        "groupId": user.groupId!.trim(),
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
    } catch (e) {
      //
    }

    return retVal;
  }

  //Join Group
  Future<String> joinGroup(
      {required String groupId, required String userId}) async {
    String message = "error";
    List<String> members = [];

    try {
      members.add(userId);
      await groupsCollection.doc(groupId).update({
        "members": FieldValue.arrayUnion(members),
      });
      await usersCollection.doc(userId).update({
        "groupId": groupId.trim(),
      });
      message = "success";
    } catch (e) {
      print("y a un problème pour joindre le groupe");
      print(e);
    }
    return message;
  }

  /* ---------------------------- */
  /* ----------- BOOK ----------- */
  /* ---------------------------- */

  Future<String> addSingleBook(
      String groupId, BookModel book, int nextPicker) async {
    String message = "error";

    try {
      DocumentReference _docRef =
          await groupsCollection.doc(groupId).collection("books").add({
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

  Future<bool> hasReadTheBook(
      String groupId, String bookId, String userId) async {
    bool hasReadTheBook = false;

    try {
      DocumentSnapshot _docSnapshot = await groupsCollection
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(userId)
          .get();

      if (_docSnapshot.exists) {
        hasReadTheBook = true;
      }
    } catch (e) {
      //print(e);
    }

    return hasReadTheBook;
  }

  Future<String> changePicker(String groupId) async {
    String message = "error";

    try {
      await groupsCollection
          .doc(groupId)
          .update({"indexPickingBook": FieldValue.increment(1)});

      message = "success";
    } catch (e) {
      //
    }

    return message;
  }

  Future<String> changePickerFromStart(String groupId) async {
    String retVal = "error";

    try {
      await groupsCollection.doc(groupId).update({"indexPickingBook": 0});
    } catch (e) {
      //
    }

    return retVal;
  }
}
