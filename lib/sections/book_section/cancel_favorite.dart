import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_profile.dart';

import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/buttons/cancel_button.dart';
import 'package:book_club/shared/constraints.dart';

import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';

import 'package:flutter/material.dart';

class CancelFavorite extends StatelessWidget {
  final BookModel favoriteBook;
  final GroupModel currentGroup;
  final UserModel currentUser;

  const CancelFavorite({
    Key? key,
    required this.favoriteBook,
    required this.currentGroup,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _currentBookCoverUrl() {
      String currentBookCoverUrl;

      if (favoriteBook.cover == "") {
        currentBookCoverUrl =
            "https://cdn.pixabay.com/photo/2020/12/14/15/52/book-5831278_1280.jpg";
      } else {
        currentBookCoverUrl = favoriteBook.cover!;
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
            height: 300,
            child: ShadowContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      height: 150,
                      child: Image.network(_currentBookCoverUrl())),
                  ElevatedButton(
                    onPressed: () {
                      DBFuture().cancelFavoriteBook(
                          currentGroup.id!, favoriteBook.id!, currentUser.uid!);
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
                    child: const Text("Supprimer de vos favoris ?"),
                  ),
                  const CancelButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
