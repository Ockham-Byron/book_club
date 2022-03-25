import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_profile.dart';
import 'package:book_club/screens/create/add_review.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/constraints.dart';

import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';

import 'package:flutter/material.dart';

class FinishedBook extends StatelessWidget {
  final BookModel finishedBook;
  final GroupModel currentGroup;
  final UserModel currentUser;

  const FinishedBook({
    Key? key,
    required this.finishedBook,
    required this.currentGroup,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _currentBookCoverUrl() {
      String currentBookCoverUrl;

      if (finishedBook.cover == "") {
        currentBookCoverUrl =
            "https://cdn.pixabay.com/photo/2020/12/14/15/52/book-5831278_1280.jpg";
      } else {
        currentBookCoverUrl = finishedBook.cover!;
      }

      return currentBookCoverUrl;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return computerLayout(globalWidget(_currentBookCoverUrl, context));
        } else {
          return globalWidget(_currentBookCoverUrl, context);
        }
      },
    );
  }

  Scaffold globalWidget(
      String Function() _currentBookCoverUrl, BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: SizedBox(
            height: 350,
            child: ShadowContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 150,
                    child: Image.network(_currentBookCoverUrl()),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddReview(
                                    currentUser: currentUser,
                                    bookId: finishedBook.id!,
                                    fromRoute: ProfileAdmin(
                                      currentGroup: currentGroup,
                                      currentUser: currentUser,
                                    ),
                                    currentGroup: currentGroup,
                                  )));
                    },
                    child: const Text("Vous avez terminé le livre ?"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DBFuture().dontWantToReadBook(
                          finishedBook.id!, currentUser.uid!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileAdmin(
                                  currentUser: currentUser,
                                  currentGroup: currentGroup,
                                )),
                      );
                    },
                    child:
                        const Text("Vous ne comptez pas terminer ce livre ?"),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "ANNULER",
                        style: TextStyle(
                            color: Theme.of(context).focusColor, fontSize: 20),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
