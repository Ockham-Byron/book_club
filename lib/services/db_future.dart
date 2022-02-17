import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
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

  //edit User
  Future<String> editUserPseudo(String userId, String pseudo) async {
    String message = "error";

    try {
      await usersCollection.doc(userId).update({
        "pseudo": pseudo.trim(),
      });
      message = "success";
    } catch (e) {
      //print(e);
    }
    return message;
  }

  Future<String> editUserMail(String userId, String mail) async {
    String retVal = "error";

    try {
      await usersCollection.doc(userId).update({
        "email": mail.trim(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> editUserPicture(String userId, String pictureUrl) async {
    String retVal = "error";

    try {
      await usersCollection.doc(userId).update({
        "pictureUrl": pictureUrl.trim(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  //Delete User
  Future<String> deleteUserFromDb(String userId) async {
    String retVal = "error";

    try {
      await usersCollection.doc(userId).delete();

      retVal = "success";
    } catch (e) {
      //print(e);
    }
    return retVal;
  }

  Future<String> deleteUserFromGroup(String userId, String groupId) async {
    String retVal = "error";

    try {
      await groupsCollection.doc(groupId).update({
        "members": FieldValue.arrayRemove([userId])
      });

      retVal = "success";
    } catch (e) {
      //print(e);
    }
    return retVal;
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
      //
    }
    return message;
  }

  //Manage picker of the next book
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
    String message = "error";

    try {
      await groupsCollection.doc(groupId).update({"indexPickingBook": 0});
      message = "success";
    } catch (e) {
      //
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

  //edit Book
  Future<String> editBook({
    required String groupId,
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
    required String bookCover,
    required int bookPages,
    required Timestamp dueDate,
  }) async {
    String message = "error";

    try {
      await groupsCollection
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .update({
        "title": bookTitle.trim(),
        "author": bookAuthor.trim(),
        "cover": bookCover.trim(),
        "length": bookPages,
        "dueDate": dueDate,
      });
      message = "success";
    } catch (e) {
      //print(e);
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

  Future<String> reviewBook(String groupId, String bookId, String userId,
      int rating, String review, bool favorite) async {
    String retVal = "error";
    List<String> readBooks = [];

    try {
      await groupsCollection
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(userId)
          .set({"rating": rating, "review": review, "favorite": favorite});

      //add finished Book in user profile
      readBooks.add(bookId);
      await usersCollection.doc(userId).update({
        "readBooks": FieldValue.arrayUnion(readBooks),
        //"readPages": FieldValue.increment(nbPages)
      });

      retVal = "success";
    } catch (e) {
      //print(e);
    }

    return retVal;
  }

  Future<String> favoriteBook(
    String groupId,
    String bookId,
    String userId,
  ) async {
    String message = "error";
    List<String> favoriteBooks = [];

    try {
      favoriteBooks.add(bookId);
      await usersCollection.doc(userId).update({
        "favoriteBooks": FieldValue.arrayUnion(favoriteBooks),
      });
      message = "success";
    } catch (e) {
      //print(e);
    }

    return message;
  }
}
