import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_profile.dart';

import 'package:book_club/services/db_future.dart';

import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';

import 'package:flutter/material.dart';

class CancelRead extends StatelessWidget {
  final BookModel readBook;
  final GroupModel currentGroup;
  final UserModel currentUser;

  const CancelRead({
    Key? key,
    required this.readBook,
    required this.currentGroup,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _currentBookCoverUrl() {
      String currentBookCoverUrl;

      if (readBook.cover == "") {
        currentBookCoverUrl =
            "https://cdn.pixabay.com/photo/2020/12/14/15/52/book-5831278_1280.jpg";
      } else {
        currentBookCoverUrl = readBook.cover!;
      }

      return currentBookCoverUrl;
    }

    return Scaffold(
      body: BackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 20),
          child: ShadowContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    height: 150, child: Image.network(_currentBookCoverUrl())),
                ElevatedButton(
                  onPressed: () {
                    DBFuture().cancelReadBook(
                        currentGroup.id!, readBook.id!, currentUser.uid!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileAdmin(
                          currentUser: currentUser,
                          currentGroup: currentGroup,
                        ),
                      ),
                    );
                  },
                  child: const Text("Finalement vous ne l'avez pas lu ?"),
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
    );
  }
}
