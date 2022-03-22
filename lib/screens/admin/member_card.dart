import 'dart:math';

import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/services/auth.dart';
import 'package:book_club/shared/display_services.dart';

import 'package:flutter/material.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/book_model.dart';
import '../../services/db_future.dart';
import '../../services/db_stream.dart';
import 'package:badges/badges.dart';

class MemberCard extends StatelessWidget {
  final UserModel user;
  final UserModel currentUser;
  final GroupModel currentGroup;
  const MemberCard(
      {Key? key,
      required this.user,
      required this.currentUser,
      required this.currentGroup})
      : super(key: key);

  // bool withProfilePicture() {
  //   if (user.pictureUrl == "") {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  String getUserPseudo() {
    String userPseudo;
    if (user.pseudo == null) {
      userPseudo = "personne";
    } else {
      userPseudo = user.pseudo!;
    }
    return "${userPseudo[0].toUpperCase()}${userPseudo.substring(1)}";
  }

  int getUserReadBooks() {
    int readBooks;
    if (user.readBooks != null) {
      readBooks = user.readBooks!.length;
    } else {
      readBooks = 0;
    }
    return readBooks;
  }

  void _deleteUser(String userId, String groupId, BuildContext context) async {
    try {
      String _returnString = await AuthService().deleteUser();

      if (_returnString == "success") {
        DBFuture().deleteUserFromDb(
          user.uid!,
        );

        DBFuture().deleteUserFromGroup(
          user.uid!,
          currentGroup.id!,
        );

        Fluttertoast.showToast(
            msg: "Compte supprimé, bonjour tristesse...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
        if (currentUser.uid == user.uid) {
          _signOut(context);
        }
      } else if (_returnString == "error" || _returnString == null) {
        Fluttertoast.showToast(
            msg:
                "Opération sensible ! Vous devez vous connecter de nouveau pour la mener en toute sécurité.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      //print(e);
    }
  }

  void _signOut(BuildContext context) async {
    String _returnedString = await AuthService().signOut();
    if (_returnedString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AppRoot(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _displayChangeLeader() {
      if (user.uid == currentGroup.leader) {
        return TextButton(
            onPressed: () {},
            child: Text(
              "Changer d'admin",
              style: TextStyle(color: Theme.of(context).focusColor),
            ));
      } else {
        return Container();
      }
    }

    Widget displayDeleteIcon() {
      if (currentUser.uid == currentGroup.leader ||
          currentUser.uid == user.uid) {
        return IconButton(
            onPressed: () => _deleteUser(user.uid!, currentGroup.id!, context),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).focusColor,
            ));
      } else {
        return Container();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(20.0),
              child: displayProfileWithBadge(user, currentGroup)),
          Container(
            padding: const EdgeInsets.all(20),
            height: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getUserPseudo(),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.auto_stories,
                      color: Theme.of(context).focusColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Livres lus : ",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Text(
                      getUserReadBooks().toString(),
                      style: TextStyle(
                          color: Theme.of(context).focusColor, fontSize: 15),
                    ),
                    const Text(
                      " / ",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    StreamBuilder<List<BookModel>>(
                        stream: DBStream().getAllBooks(currentGroup.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else {
                            List<BookModel> books = snapshot.data!;
                            return Text(
                              books.length.toString(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            );
                          }
                        }),
                  ],
                ),
                _displayChangeLeader(),
              ],
            ),
          ),
          displayDeleteIcon()
        ],
      ),
    );
  }
}
