import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/create/add_book.dart';
import 'package:flutter/material.dart';

class SingleBookCard extends StatelessWidget {
  final UserModel currentUser;
  final GroupModel currentGroup;
  const SingleBookCard(
      {Key? key, required this.currentUser, required this.currentGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goToAddBook() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddBook(
            // onGroupCreation: false,
            // onError: false,
            // currentUser: currentUser,
            currentGroup: currentGroup,
          ),
        ),
      );
    }

    if (currentGroup.currentBookId != null) {
      print(currentGroup.currentBookId);
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Livre à lire pour le ",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                // Text(
                //   _displayDueDate(),
                //   style: TextStyle(
                //       fontSize: 30,
                //       fontWeight: FontWeight.w500,
                //       color: Theme.of(context).primaryColor),
                // ),
                // Text(_displayRemainingDays()),
                // _displayCurrentBookInfo(),
                // SizedBox(
                //   height: 30,
                // ),
                // _displayNextBookInfo(),
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(
                right: 50,
              ),
              child: Image.network(
                  "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Il n'y a pas encore de livre dans ce groupe ;(",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => _goToAddBook(),
              child: const Text("Ajouter le premier livre"),
            ),
          ],
        ),
      );
    }
  }
}
