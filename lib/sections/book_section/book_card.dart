import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/history/book_detail.dart';
import 'package:book_club/sections/book_section/cancel_favorite.dart';
import 'package:book_club/sections/book_section/cancel_read.dart';
import 'package:book_club/sections/book_section/finish_book.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/display_services.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  final BookModel? book;

  final GroupModel currentGroup;
  final UserModel currentUser;
  final String sectionCategory;

  const BookCard(
      {Key? key,
      this.book,
      required this.currentGroup,
      required this.currentUser,
      required this.sectionCategory})
      : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  void _goToBookDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetail(
          currentGroup: widget.currentGroup,
          currentBook: widget.book!,
          currentUser: widget.currentUser,
        ),
      ),
    );
  }

  Widget _displayBookCard() {
    return StreamBuilder<BookModel>(
        stream: DBStream().getBookData(
            groupId: widget.currentGroup.id!, bookId: widget.book!.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            BookModel _currentBook = snapshot.data!;
            return GestureDetector(
              onTap: () => _goToBookDetail(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: 150,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image:
                                NetworkImage(displayBookCoverUrl(_currentBook)),
                            fit: BoxFit.fill),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _currentBook.title ?? "Pas de titre",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, color: Theme.of(context).focusColor),
                    ),
                    Text(
                      _currentBook.author ?? "Pas d'auteur",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    CancelButton(
                      bookCard: widget,
                      context: context,
                      currentBook: _currentBook,
                    )
                  ],
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return _displayBookCard();
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({
    Key? key,
    required this.bookCard,
    required this.context,
    required this.currentBook,
  }) : super(key: key);

  final BookCard bookCard;
  final BuildContext context;
  final BookModel currentBook;

  @override
  Widget build(BuildContext context) {
    if (bookCard.sectionCategory == "empruntables" &&
        currentBook.ownerId != bookCard.currentUser.uid) {
      return IconButton(
        onPressed: () => _showDialogBorrow(),
        icon: Icon(
          Icons.add_task,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "emprunter",
      );
    }
    if (bookCard.sectionCategory == "empruntables" &&
        currentBook.ownerId == bookCard.currentUser.uid) {
      print("coucou");
      return IconButton(
        onPressed: () => _showDialogNoLendable(),
        icon: Icon(
          Icons.cancel,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "je ne prête plus ce livre",
      );
    } else if (bookCard.sectionCategory == "en circulation" &&
        currentBook.ownerId != bookCard.currentUser.uid) {
      return IconButton(
        onPressed: () => _showDialogReservation(),
        icon: Icon(
          Icons.bookmark_add,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "liste d'attente",
      );
    } else if (currentBook.waitingList!.contains(bookCard.currentUser.uid)) {
      return IconButton(
        onPressed: () => _showDialogReservation(),
        icon: Icon(
          Icons.bookmark_remove,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "annuler réservation",
      );
    } else if (bookCard.sectionCategory == "en circulation" &&
        currentBook.ownerId == bookCard.currentUser.uid) {
      return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.cable,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "modifier l'emprunteur",
      );
    } else if (bookCard.sectionCategory == "que vous avez prêtés") {
      return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.bookmark_add,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "il est rendu",
      );
    } else {
      return IconButton(
          onPressed: () {
            if (bookCard.sectionCategory == "continuer") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FinishedBook(
                            finishedBook: currentBook,
                            currentGroup: bookCard.currentGroup,
                            currentUser: bookCard.currentUser,
                          )));
            } else if (bookCard.sectionCategory == "favoris") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CancelFavorite(
                            favoriteBook: currentBook,
                            currentGroup: bookCard.currentGroup,
                            currentUser: bookCard.currentUser,
                          )));
            } else if (bookCard.sectionCategory == "lus") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CancelRead(
                            readBook: currentBook,
                            currentGroup: bookCard.currentGroup,
                            currentUser: bookCard.currentUser,
                          )));
            }
          },
          icon: Icon(
            Icons.close,
            color: Theme.of(context).focusColor,
          ));
    }
  }

  //Alert popup non lendable
  Future<void> _showDialogNoLendable() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Sortir ce livre de la boucle de prêts ?",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    "Il sera toujours possible de consulter les détails du livre, mais plus personne ne pourra l'emprunter."),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Annuler".toUpperCase(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await DBFuture().changeLendableStatus(
                            groupId: bookCard.currentGroup.id!,
                            bookId: bookCard.book!.id!,
                            isLendable: false);
                        Navigator.of(context).pop();
                      },
                      child: Text("Je confirme".toUpperCase(),
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('X',
                  style: TextStyle(color: Theme.of(context).focusColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Alert popup Borrow
  Future<void> _showDialogBorrow() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Emprunter ce livre ?",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  "Vous empruntez ce livre à ",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<UserModel>(
                  stream: DBStream().getUserData(currentBook.ownerId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      UserModel owner = snapshot.data!;
                      return Text(
                        owner.pseudo!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Annuler".toUpperCase(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await DBFuture().borrowBook(
                            groupId: bookCard.currentGroup.id!,
                            bookId: bookCard.book!.id!,
                            userId: bookCard.currentUser.uid!);
                        Navigator.of(context).pop();
                      },
                      child: Text("Je confirme".toUpperCase(),
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('X',
                  style: TextStyle(color: Theme.of(context).focusColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Alert popup reservation
  Future<void> _showDialogReservation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Réserver ce livre ?",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                StreamBuilder<BookModel>(
                    stream: DBStream().getBookData(
                        groupId: bookCard.currentGroup.id!,
                        bookId: bookCard.book!.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else {
                        BookModel _selectedBook = snapshot.data!;
                        int nbOfWaitingUsers =
                            _selectedBook.waitingList!.length;
                        return Column(
                          children: [
                            Text(
                              "Ce livre a",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              nbOfWaitingUsers.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).focusColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text("membres en file d'attente",
                                textAlign: TextAlign.center)
                          ],
                        );
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Annuler".toUpperCase(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await DBFuture().reserveBook(
                            groupId: bookCard.currentGroup.id!,
                            bookId: bookCard.book!.id!,
                            userId: bookCard.currentUser.uid!);
                        Navigator.of(context).pop();
                      },
                      child: Text("Je confirme".toUpperCase(),
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('X',
                  style: TextStyle(color: Theme.of(context).focusColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
