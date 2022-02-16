import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/screens/create/add_review.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';

class FinishButton extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final Widget fromScreen;
  const FinishButton(
      {Key? key,
      required this.currentGroup,
      required this.currentUser,
      required this.fromScreen})
      : super(key: key);

  @override
  _FinishButtonState createState() => _FinishButtonState();
}

class _FinishButtonState extends State<FinishButton> {
  void _goToReview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddReview(
            currentGroup: widget.currentGroup,
            currentUser: widget.currentUser,
            bookId: widget.currentGroup.currentBookId!,
            fromRoute: widget.fromScreen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBFuture().hasReadTheBook(widget.currentGroup.id!,
          widget.currentGroup.currentBookId!, widget.currentUser.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Loading();
        } else {
          if (snapshot.data == true) {
            return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).focusColor.withOpacity(0.5),
                    border: Border.all(
                        width: 3, color: Theme.of(context).focusColor),
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                child: const Text(
                  "Livre lu",
                  style: TextStyle(color: Colors.white),
                ));
          } else {
            return ElevatedButton(
              onPressed: _goToReview,
              child: const Text("Livre terminé !"),
            );
          }
        }
      },
    );
  }
}