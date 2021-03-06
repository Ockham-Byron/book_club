import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/edit/edit_book.dart';
import 'package:book_club/screens/history/book_detail.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/buttons/finish_button.dart';
import 'package:book_club/shared/display_services.dart';
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

  Widget _displayEdit(BookModel _currentBook) {
    if (widget.currentUser.uid == _currentBook.submittedBy) {
      return RotatedBox(
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
      );
    } else {
      return Container();
    }
  }

  Widget _displayCurrentBookInfo(BookModel _currentBook) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 150,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: NetworkImage(displayBookCoverUrl(_currentBook)),
                fit: BoxFit.fill),
          ),
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
                book: _currentBook,
                bookId: widget.currentGroup.currentBookId!,
                fromScreen: "singleBookHome",
              ),
            ],
          ),
        ),
        _displayEdit(_currentBook)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: (() => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BookDetail(
                              currentBook: _currentBook,
                              currentGroup: widget.currentGroup,
                              currentUser: widget.currentUser,
                            )))),
                    child: Column(
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
                    ),
                  ),
                );
              }
            }
          }
        });
  }
}
