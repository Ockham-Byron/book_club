import 'dart:math';

import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';

import 'package:flutter/material.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class MemberCard extends StatelessWidget {
  final UserModel user;
  final GroupModel currentGroup;
  MemberCard({Key? key, required this.user, required this.currentGroup})
      : super(key: key);

  bool withProfilePicture() {
    if (user.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

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

  // int getnbOfGroupBooks() {
  //   int nbOfGroupBooks;
  //   if (currentGroup.nbOfBooks != null) {
  //     nbOfGroupBooks = currentGroup.nbOfBooks!;
  //   } else {
  //     nbOfGroupBooks = 0;
  //   }
  //   return nbOfGroupBooks;
  // }

  // Used to generate random integers for the random colors
  final _random = Random();

  @override
  Widget build(BuildContext context) {
    final Color? _foregroundColor =
        Colors.primaries[_random.nextInt(Colors.primaries.length)]
            [_random.nextInt(9) * 100];
    Widget displayCircularAvatar() {
      if (withProfilePicture()) {
        return CircularProfileAvatar(
          user.pictureUrl!,
          showInitialTextAbovePicture: false,
          radius: 50,
        );
      } else {
        return CircularProfileAvatar(
          "https://digitalpainting.school/static/img/default_avatar.png",
          foregroundColor: _foregroundColor ?? Colors.blue,
          initialsText: Text(
            getUserPseudo()[0].toUpperCase(),
            style: const TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          showInitialTextAbovePicture: true,
        );
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: displayCircularAvatar(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            height: 100,
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
                      color: Theme.of(context).primaryColor,
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
                          color: Theme.of(context).primaryColor, fontSize: 15),
                    ),
                    const Text(
                      " / ",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const Text(
                      "0",
                      //getnbOfGroupBooks().toString(),
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
