import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/review_model.dart';
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
        readBooks: List<String>.from(snapshot.data()!["readBooks"]),
        favoriteBooks: List<String>.from(snapshot.data()!["favoriteBooks"]),
        dontWantToReadBooks:
            List<String>.from(snapshot.data()!["dontWantToReadBooks"]));
  }

  // get user doc stream
  Stream<UserModel> getUserData(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  //users list from snapshots
  List<UserModel> _listOfMembers(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
          uid: doc.id,
          pseudo: doc.data()["pseudo"],
          pictureUrl: doc.data()["pictureUrl"],
          email: doc.data()["email"],
          groupId: doc.data()["groupId"],
          readBooks: List<String>.from(doc.data()["readBooks"]),
          favoriteBooks: List<String>.from(doc.data()["favoriteBooks"]),
          dontWantToReadBooks:
              List<String>.from(doc.data()["dontWantToReadBooks"]));
    }).toList();
  }

  //stream of users list
  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection("users").snapshots().map(_listOfMembers);
  }

  //groups list from snapshots
  List<GroupModel> _listOfGroups(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return GroupModel(
        id: doc.id,
        name: doc.data()["name"],
        leader: doc.data()["leader"],
        currentBookId: doc.data()["currentBookId"],
        indexPickingBook: doc.data()["indexPickingBook"],
        members: List<String>.from(doc.data()["members"]),
      );
    }).toList();
  }

  //stream of groups list
  Stream<List<GroupModel>> getAllGroups() {
    return _firestore.collection("groups").snapshots().map(_listOfGroups);
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

  //book list from snapshot
  List<BookModel> _booksListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return BookModel(
          id: doc.id,
          title: doc.data()["title"],
          author: doc.data()["author"],
          length: doc.data()["length"],
          dueDate: doc.data()["dueDate"],
          submittedBy: doc.data()["submittedBy"],
          cover: doc.data()["cover"]);
    }).toList();
  }

  //books Stream
  Stream<List<BookModel>> getAllBooks(String groupId) {
    return _firestore
        .collection("groups")
        .doc(groupId)
        .collection("books")
        .snapshots()
        .map(_booksListFromSnapshot);
  }

  //book data from snapshot
  BookModel _bookDataFromSnapshot(DocumentSnapshot snapshot) {
    return BookModel(
        id: snapshot.id,
        title: snapshot.get("title"),
        author: snapshot.get("author"),
        length: snapshot.get("length"),
        dueDate: snapshot.get("dueDate"),
        cover: snapshot.get("cover"),
        submittedBy: snapshot.get("submittedBy"));
  }

  //get book doc stream
  Stream<BookModel> getBookData(
      {required String groupId, required String bookId}) {
    // BookModel book = BookModel();
    return _firestore
        .collection("groups")
        .doc(groupId)
        .collection("books")
        .doc(bookId)
        .snapshots()
        .map(_bookDataFromSnapshot);
  }

  //get bookmodel
  Future<BookModel> getBook(String bookId, String groupId) async {
    BookModel book = BookModel();

    try {
      DocumentSnapshot<Map<String, dynamic>> _docSnapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .get();
      book = _bookDataFromSnapshot(_docSnapshot);
    } catch (e) {
      //print(e);
    }

    return book;
  }

  // review data from snapshots
  ReviewModel _reviewDataFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ReviewModel(
      reviewId: snapshot.id,
      rating: snapshot.get("rating"),
      review: snapshot.get("review"),
      favorite: snapshot.get("favorite"),
    );
  }

  // get review doc stream
  Stream<ReviewModel> getReviewData(
      String groupId, String bookId, String reviewId) {
    return _firestore
        .collection("groups")
        .doc(groupId)
        .collection("books")
        .doc(bookId)
        .collection("reviews")
        .doc(reviewId)
        .snapshots()
        .map(_reviewDataFromSnapshot);
  }

  //get review list from snapshot

  List<ReviewModel> _reviewsListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return ReviewModel(
        reviewId: doc.id,
        rating: doc.data()["rating"],
        review: doc.data()["review"],
        favorite: doc.data()["favorite"],
      );
    }).toList();
  }

  //reviews Stream
  Stream<List<ReviewModel>> getAllReviews(String groupId, String bookId) {
    return _firestore
        .collection("groups")
        .doc(groupId)
        .collection("books")
        .doc(bookId)
        .collection("reviews")
        .snapshots()
        .map(_reviewsListFromSnapshot);
  }
}
