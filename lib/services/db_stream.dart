import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // user data from snapshots
  UserModel _userDataFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      uid: snapshot.id,
      pseudo: snapshot.get("pseudo"),
      email: snapshot.get("email"),
      pictureUrl: snapshot.get("pictureUrl"),
      groupId: snapshot.data()!["groupId"],
    );
  }

  // get user doc stream
  Stream<UserModel> getUserData(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  // group data from snapshots
  GroupModel _groupDataFromSnapshot(DocumentSnapshot snapshot) {
    return GroupModel(
        id: snapshot.id,
        name: snapshot.get("name"),
        leader: snapshot.get("leader"),
        currentBookId: snapshot.get("currentBookId"),
        indexPickingBook: snapshot.get("indexPickingBook"),
        members: List<String>.from(snapshot.get("members")));
  }

  //get group doc stream
  Stream<GroupModel> getGroupData(String groupId) {
    return _firestore
        .collection("groups")
        .doc(groupId)
        .snapshots()
        .map(_groupDataFromSnapshot);
  }

  //book data from snapshot
  BookModel _bookDataFromSnapshot(DocumentSnapshot snapshot) {
    return BookModel(
        id: snapshot.id,
        title: snapshot.get("title"),
        author: snapshot.get("author"),
        length: snapshot.get("length"),
        dueDate: snapshot.get("dueDate"),
        cover: snapshot.get("cover"));
  }

  //get book doc stream
  Stream<BookModel> getBookData(
      {required String groupId, required String bookId}) {
    return _firestore
        .collection("groups")
        .doc(groupId)
        .collection("books")
        .doc(bookId)
        .snapshots()
        .map(_bookDataFromSnapshot);
  }
}
