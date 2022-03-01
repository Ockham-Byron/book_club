import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';

import 'package:book_club/screens/create/add_review.dart';
import 'package:book_club/screens/history/book_detail.dart';
import 'package:book_club/screens/home/GroupHome/single_book_card.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';

class FinishButton extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final BookModel book;
  final String bookId;
  final String fromScreen;
  const FinishButton(
      {Key? key,
      required this.currentGroup,
      required this.currentUser,
      required this.book,
      required this.bookId,
      required this.fromScreen})
      : super(key: key);

  @override
  _FinishButtonState createState() => _FinishButtonState();
}

class _FinishButtonState extends State<FinishButton> {
  void _goToReview() {
    Widget goToScreen;
    if (widget.fromScreen == "bookDetail") {
      goToScreen = BookDetail(
          currentGroup: widget.currentGroup,
          currentBook: widget.book,
          currentUser: widget.currentUser);
    } else if (widget.fromScreen == "singleBookHome") {
      goToScreen = const AppRoot();
    } else {
      goToScreen = const AppRoot();
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddReview(
            currentGroup: widget.currentGroup,
            currentUser: widget.currentUser,
            bookId: widget.currentGroup.currentBookId!,
            fromRoute: goToScreen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String finishedMessage = "Livre terminé";
    return FutureBuilder(
      future: DBFuture().hasReadTheBook(
          widget.currentGroup.id!, widget.bookId, widget.currentUser.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Loading();
        } else {
          if (snapshot.data == true) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: Theme.of(context).focusColor,
                ),
                Text(
                  "Livre lu",
                  style: TextStyle(color: Theme.of(context).focusColor),
                )
              ],
            );
          } else {
            if (widget.fromScreen == "singleBookHome") {
              finishedMessage = "J'ai terminé";
            } else {
              finishedMessage =
                  "Indique que, toi aussi, tu as terminé ce livre";
            }
            return ElevatedButton(
              onPressed: _goToReview,
              child: Text(
                finishedMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
        }
      },
    );
  }
}
