import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/screens/create/add_book.dart';
import 'package:book_club/screens/edit/edit_book.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/buttons/finish_button.dart';
import 'package:book_club/shared/loading.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleBookCard extends StatefulWidget {
  final UserModel currentUser;
  final GroupModel currentGroup;

  const SingleBookCard(
      {Key? key, required this.currentUser, required this.currentGroup})
      : super(key: key);

  @override
  _SingleBookCardState createState() => _SingleBookCardState();
}

class _SingleBookCardState extends State<SingleBookCard> {
  String _displayDueDate(BookModel _currentBook) {
    String rdv;
    if (_currentBook.dueDate != null) {
      var dueDate = _currentBook.dueDate!.toDate();
      rdv = DateFormat("dd/MM").format(dueDate);
    } else {
      rdv = "pas de rdv établi";
    }
    return rdv;
  }

  String _displayRemainingDays(BookModel _currentBook) {
    String currentBookDue;
    var today = DateTime.now();

    if (_currentBook.id != null) {
      var _currentBookDue = _currentBook.dueDate;

      var _remainingDays = _currentBookDue!.toDate().difference(today);
      if (_currentBookDue == Timestamp.now()) {
        currentBookDue = "pas de rdv fixé";
      } else if (_remainingDays.isNegative) {
        currentBookDue = "le rdv a déjà eu lieu";
      } else if (_remainingDays.inDays == 1) {
        currentBookDue = "rdv demain !";
      } else if (_remainingDays.inDays == 0) {
        currentBookDue = "rdv aujourd'hui !";
      } else {
        currentBookDue = "Rdv pour échanger dans " +
            _remainingDays.inDays.toString() +
            " jours";
      }
    } else {
      currentBookDue = "pas de rdv établi";
    }
    return currentBookDue;
  }

  String _currentBookCoverUrl(BookModel _currentBook) {
    String currentBookCoverUrl;

    if (_currentBook.cover == "") {
      currentBookCoverUrl =
          "https://www.azendportafolio.com/static/img/not-found.png";
    } else {
      currentBookCoverUrl = _currentBook.cover!;
    }

    return currentBookCoverUrl;
  }

  Widget _displayCurrentBookInfo(BookModel _currentBook) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 150,
          width: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(_currentBookCoverUrl(_currentBook)))),
        ),
        SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentBook.title ?? "pas de titre",
                style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                _currentBook.author ?? "pas d'auteur",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                _currentBook.length.toString() + " pages",
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
              FinishButton(
                currentGroup: widget.currentGroup,
                currentUser: widget.currentUser,
                fromScreen: const AppRoot(),
              ),
            ],
          ),
        ),
        RotatedBox(
          quarterTurns: 3,
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditBook(
                          currentGroup: widget.currentGroup,
                          currentBook: _currentBook,
                          currentUser: widget.currentUser,
                          fromScreen: "fromHome",
                        )));
              },
              child: Text(
                "MODIFIER",
                style: TextStyle(color: Theme.of(context).focusColor),
              )),
        )
      ],
    );
  }

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
            currentGroup: widget.currentGroup,
          ),
        ),
      );
    }

    if (widget.currentGroup.currentBookId != null) {
      //print("bookId : " + widget.currentGroup.currentBookId.toString());
      return StreamBuilder<BookModel>(
          stream: DBStream().getBookData(
              groupId: widget.currentGroup.id!,
              bookId: widget.currentGroup.currentBookId!),
          initialData: BookModel(),
          builder: (context, snapshot) {
            BookModel _currentBook = BookModel();
            if (snapshot.connectionState == ConnectionState.waiting) {
              //print("waiting");
              return const Loading();
            } else {
              if (snapshot.hasError) {
                //print("y a une erreur : " + snapshot.error.toString());
                return const Loading();
              } else {
                if (!snapshot.hasData) {
                  //print("pas de data");
                  return const Loading();
                } else {
                  _currentBook = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Livre à lire pour le ",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Text(
                            _displayDueDate(_currentBook),
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor),
                          ),
                          Text(_displayRemainingDays(_currentBook)),
                          const SizedBox(
                            height: 40,
                          ),
                          _displayCurrentBookInfo(_currentBook),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      )
                    ],
                  );
                }
              }
            }
          });
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
