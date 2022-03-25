import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_profile.dart';

import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/constraints.dart';

import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:book_club/shared/display_services.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return Center(
            child: SizedBox(
              height: mobileContainerMaxHeight,
              width: mobileMaxWidth,
              child: globalWidget(context),
            ),
          );
        } else {
          return globalWidget(context);
        }
      },
    );
  }

  Scaffold globalWidget(BuildContext context) {
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
                      child: Image.network(displayBookCoverUrl(readBook))),
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
      ),
    );
  }
}
