import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_profile.dart';
import 'package:book_club/screens/create/add_review.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:book_club/shared/loading.dart';
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
    return Scaffold(
        body: BackgroundContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 230, horizontal: 20),
        child: StreamBuilder<UserModel>(
            stream: DBStream().getUserData(currentUser.uid!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              } else {
                UserModel _currentUser = snapshot.data!;
                return ShadowContainer(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => AddReview(
                        //               bookId: finishedBook.id!,
                        //               fromRoute: ReviewHistory(
                        //                 bookId: finishedBook.id!,
                        //                 groupId: currentGroup.id!,
                        //                 currentBook: finishedBook,
                        //                 currentGroup: currentGroup,
                        //                 currentUser: currentUser,
                        //                 authModel: authModel,
                        //               ),
                        //               currentGroup: currentGroup,
                        //             )));
                      },
                      child: const Text("Vous avez terminé le livre ?"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DBFuture().dontWantToReadBook(
                            finishedBook.id!, _currentUser.uid!);
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
                              color: Theme.of(context).focusColor,
                              fontSize: 20),
                        ))
                  ],
                ));
              }
            }),
      ),
    ));
  }
}
