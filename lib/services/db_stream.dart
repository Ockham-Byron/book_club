import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBStream {
  final String? userId;

  DBStream({this.userId});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // user data from snapshots
  UserModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
        uid: userId,
        pseudo: snapshot.get("pseudo"),
        email: snapshot.get("email"),
        pictureUrl: snapshot.get("pictureUrl"),
        groupId: snapshot.get("groupId"));
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

  // Stream<GroupModel> getcurrentGroup(String groupId) {
  //   return _firestore.collection("groups").doc(groupId).snapshots().map(
  //       (docSnapshot) => GroupModel.fromDocumentSnapshot(doc: docSnapshot));
  // }
}
