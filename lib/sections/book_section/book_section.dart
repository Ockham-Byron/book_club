import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/history/book_history.dart';
import 'package:book_club/sections/book_section/book_card.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';

class BookSection extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;

  final String sectionCategory;
  const BookSection(
      {Key? key,
      required this.currentGroup,
      required this.currentUser,
      required this.sectionCategory})
      : super(key: key);

  @override
  _BookSectionState createState() => _BookSectionState();
}

class _BookSectionState extends State<BookSection> {
  String nothingText = "";
  String nothingImage = "";
  VoidCallback? goTo;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookModel>>(
      stream: DBStream().getAllBooks(widget.currentGroup.id!),
      builder: (context, snapshot) {
        if (widget.sectionCategory == "favoris") {
          nothingText = "pas de favoris";
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else {
          if (snapshot.hasError) {
            return const Loading();
          } else {
            if (!snapshot.hasData) {
              return const Loading();
            } else {
              //define the selected lists of books
              List<BookModel> allBooks = snapshot.data!;
              List<BookModel> selectedBooks = [];
              if (widget.sectionCategory == "continuer") {
                for (var book in allBooks) {
                  if (widget.currentUser.readBooks!.contains(book.id) ||
                      widget.currentUser.dontWantToReadBooks!
                          .contains(book.id)) {
                  } else {
                    selectedBooks.add(book);
                  }
                }
                nothingText = "Vous avez tout lu";
                nothingImage =
                    "https://upload.wikimedia.org/wikipedia/commons/7/7f/Dicoo_bienvenue.png";
              }
              if (widget.sectionCategory == "favoris") {
                for (var book in allBooks) {
                  if (widget.currentUser.favoriteBooks!.contains(book.id)) {
                    selectedBooks.add(book);
                  }
                }
                nothingText = "Aucun favori ;(";
                nothingImage =
                    "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png";
                goTo = () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => BookHistory(
                              currentGroup: widget.currentGroup,
                              currentUser: widget.currentUser)),
                      (route) => false);
                };
              }
              if (widget.sectionCategory == "lus") {
                for (var book in allBooks) {
                  if (widget.currentUser.readBooks!.contains(book.id)) {
                    selectedBooks.add(book);
                  }
                }
                nothingText = "Vous n'avez encore lu aucun livre ;(";
                nothingImage =
                    "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png";
                goTo = () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => BookHistory(
                              currentGroup: widget.currentGroup,
                              currentUser: widget.currentUser)),
                      (route) => false);
                };
              }
              if (widget.sectionCategory == "empruntables") {
                for (var book in allBooks) {
                  if (book.lenderId == null && book.isLendable == true) {
                    selectedBooks.add(book);
                  }
                }
                nothingText = "Tous les livres du groupe sont prêtés";
                nothingImage =
                    "https://upload.wikimedia.org/wikipedia/commons/7/7f/Dicoo_bienvenue.png";
              }

              if (widget.sectionCategory == "en circulation") {
                for (var book in allBooks) {
                  if (book.lenderId != null) {
                    selectedBooks.add(book);
                  }
                }
                nothingText =
                    "Aucun livre en circulation. Prêtez-vous les uns les autres !";
                nothingImage =
                    "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png";
              }

              if (widget.sectionCategory == "que vous avez prêtés") {
                for (var book in allBooks) {
                  if (book.lenderId != null &&
                      book.ownerId == widget.currentUser.uid) {
                    selectedBooks.add(book);
                  }
                }
                nothingText = "Vous n'avez aucun livre prêté en ce moment.";
                nothingImage =
                    "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png";
              }

              if (widget.sectionCategory == "que vous avez empruntés") {
                for (var book in allBooks) {
                  if (book.lenderId == widget.currentUser.uid) {
                    selectedBooks.add(book);
                  }
                }
                nothingText = "Vous n'avez aucun livre emprunté en ce moment";
                nothingImage =
                    "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png";
              }

              if (selectedBooks.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: 350,
                  height: 320,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedBooks.length + 1.clamp(0, 7),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Container();
                      } else {
                        return BookCard(
                          book: selectedBooks[index - 1],
                          currentGroup: widget.currentGroup,
                          currentUser: widget.currentUser,
                          sectionCategory: widget.sectionCategory,
                        );
                      }
                    },
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: goTo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 140, child: Image.network(nothingImage)),
                        const SizedBox(width: 20),
                        Text(
                          nothingText,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }
        }
      },
    );
  }
}
