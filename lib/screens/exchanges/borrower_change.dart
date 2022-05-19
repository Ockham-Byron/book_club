import 'dart:math';

import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';

import 'package:book_club/shared/display_services.dart';

import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../services/db_future.dart';

class BorrowerChange extends StatelessWidget {
  final UserModel user;
  final UserModel currentUser;
  final GroupModel currentGroup;
  final BookModel currentBook;
  const BorrowerChange(
      {Key? key,
      required this.user,
      required this.currentUser,
      required this.currentGroup,
      required this.currentBook})
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
        return Container(
          height: 200,
          width: 150,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).canvasColor),
          //padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
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
                  DBFuture().borrowBook(
                      groupId: currentGroup.id!,
                      userId: user.uid!,
                      bookId: currentBook.id!);
                  if (currentBook.waitingList!.contains(user.uid!)) {
                    DBFuture().cancelReserveBook(
                        groupId: currentGroup.id!,
                        bookId: currentBook.id!,
                        userId: user.uid!);
                  }
                }),
                icon: Icon(
                  Icons.add_task,
                  color: Theme.of(context).focusColor,
                ),
                tooltip: "Prêter",
              ),
            ],
          ),
        );
      }
    }

    return _displayMemberCard();
  }
}
