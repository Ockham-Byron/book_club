import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
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
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 230, horizontal: 20),
        child: ShadowContainer(
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
                // DBFuture()
                //     .dontWantToReadBook(finishedBook.id!, currentUser.uid!);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ProfileManage(
                //           currentUser: currentUser,
                //           currentGroup: currentGroup,
                //           currentBook: finishedBook,
                //           authModel: authModel)),
                // );
              },
              child: const Text("Vous ne comptez pas terminer ce livre ?"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "ANNULER",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20),
                ))
          ],
        )),
      ),
    ));
  }
}
