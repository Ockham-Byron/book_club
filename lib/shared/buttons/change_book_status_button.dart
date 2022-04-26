import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../models/user_model.dart';
import '../../screens/exchanges/change_borrower.dart';
import '../../screens/history/book_card.dart';
import '../../sections/book_section/cancel_favorite.dart';
import '../../sections/book_section/cancel_read.dart';
import '../../sections/book_section/finish_book.dart';
import '../../services/db_future.dart';
import '../../services/db_stream.dart';

class ChangeBookStatusButton extends StatelessWidget {
  const ChangeBookStatusButton({
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
    if (currentBook.lenderId == null &&
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
    if (currentBook.lenderId == null &&
        currentBook.ownerId == bookCard.currentUser.uid) {
      return IconButton(
        onPressed: () => _showDialogNoLendable(),
        icon: Icon(
          Icons.cancel,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "je ne prête plus ce livre",
      );
    } else if (currentBook.lenderId != null &&
        currentBook.ownerId != bookCard.currentUser.uid &&
        !currentBook.waitingList!.contains(bookCard.currentUser.uid) &&
        currentBook.lenderId != bookCard.currentUser.uid) {
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
        onPressed: () => _showDialogCancelReservation(),
        icon: Icon(
          Icons.bookmark_remove,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "annuler réservation",
      );
    } else if (currentBook.lenderId != null &&
        currentBook.ownerId == bookCard.currentUser.uid &&
        bookCard.sectionCategory == "en circulation") {
      return IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangeBorrower(
              currentGroup: bookCard.currentGroup,
              currentUser: bookCard.currentUser,
              currentBook: currentBook,
            ),
          ));
        },
        icon: Icon(
          Icons.cable,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "modifier l'emprunteur",
      );
    } else if (bookCard.sectionCategory == "que vous avez prêtés") {
      return IconButton(
        onPressed: () => _showDialogGiveBack(),
        icon: Icon(
          Icons.library_add_check_rounded,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "il est rendu",
      );
    } else if (bookCard.sectionCategory == "que vous avez empruntés") {
      return Container();
    } else {
      return Container();
      // return IconButton(
      //     onPressed: () {
      //       if (bookCard.sectionCategory == "continuer") {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => FinishedBook(
      //                       finishedBook: currentBook,
      //                       currentGroup: bookCard.currentGroup,
      //                       currentUser: bookCard.currentUser,
      //                     )));
      //       } else if (bookCard.sectionCategory == "favoris") {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => CancelFavorite(
      //                       favoriteBook: currentBook,
      //                       currentGroup: bookCard.currentGroup,
      //                       currentUser: bookCard.currentUser,
      //                     )));
      //       } else if (bookCard.sectionCategory == "lus") {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => CancelRead(
      //                       readBook: currentBook,
      //                       currentGroup: bookCard.currentGroup,
      //                       currentUser: bookCard.currentUser,
      //                     )));
      //       }
      //     },
      //     icon: Icon(
      //       Icons.close,
      //       color: Theme.of(context).focusColor,
      //     ));
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

  //Alert popup Give Back the Book
  Future<void> _showDialogGiveBack() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Indiquer que le livre est rendu ?",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  "Le livre est actuellement prêté à ",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<UserModel>(
                  stream: DBStream().getUserData(currentBook.lenderId!),
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
                        await DBFuture().giveBackBook(
                          groupId: bookCard.currentGroup.id!,
                          bookId: bookCard.book!.id!,
                        );
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

  //Alert popup cancerl reservation
  Future<void> _showDialogCancelReservation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Annuler la réservation de ce livre ?",
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
                        "Je reste sur la liste d'attente".toUpperCase(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await DBFuture().cancelReserveBook(
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
