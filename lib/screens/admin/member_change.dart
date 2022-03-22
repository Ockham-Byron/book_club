import 'dart:math';

import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/screens/admin/change_leader.dart';
import 'package:book_club/services/auth.dart';
import 'package:book_club/shared/display_services.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../../models/book_model.dart';
import '../../services/db_future.dart';
import '../../services/db_stream.dart';

class MemberChange extends StatelessWidget {
  final UserModel user;
  final UserModel currentUser;
  final GroupModel currentGroup;
  const MemberChange(
      {Key? key,
      required this.user,
      required this.currentUser,
      required this.currentGroup})
      : super(key: key);

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
    // // Used to generate random integers for the random colors
    final _random = Random();

    final Color? _foregroundColor = Colors
        .primaries[_random.nextInt(Colors.primaries.length)]
            [_random.nextInt(9) * 100]
        ?.withOpacity(0.6);

    Widget _displayMemberCard() {
      if (currentUser.uid == user.uid) {
        return Container();
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(20.0),
                  child: displayProfileWithBadge(
                      user, currentGroup, _foregroundColor ?? Colors.brown)),
              Text(
                getUserPseudo(),
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
              IconButton(
                onPressed: (() async {
                  DBFuture().changeLeader(currentGroup.id!, user.uid!);
                }),
                icon: Icon(
                  Icons.add_moderator,
                  color: Theme.of(context).focusColor,
                ),
                tooltip: "Choisir",
              ),
            ],
          ),
        );
      }
    }

    return _displayMemberCard();
  }
}
