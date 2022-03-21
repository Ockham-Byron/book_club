import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/history/book_detail.dart';
import 'package:book_club/sections/book_section/cancel_favorite.dart';
import 'package:book_club/sections/book_section/cancel_read.dart';
import 'package:book_club/sections/book_section/finish_book.dart';
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
  String _currentBookCoverUrl() {
    String currentBookCoverUrl;

    if (widget.book!.cover == "") {
      currentBookCoverUrl =
          "https://www.azendportafolio.com/static/img/not-found.png";
    } else {
      currentBookCoverUrl = widget.book!.cover!;
    }

    return currentBookCoverUrl;
  }

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
    return GestureDetector(
      onTap: () => _goToBookDetail(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: 150,
        child: Column(
          children: [
            SizedBox(
              width: 80,
              //height: 200,
              child: Image.network(_currentBookCoverUrl()),
            ),
            Text(
              widget.book!.title ?? "Pas de titre",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).focusColor),
            ),
            Text(
              widget.book!.author ?? "Pas d'auteur",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            IconButton(
                onPressed: () {
                  if (widget.sectionCategory == "continuer") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FinishedBook(
                                  finishedBook: widget.book!,
                                  currentGroup: widget.currentGroup,
                                  currentUser: widget.currentUser,
                                )));
                  } else if (widget.sectionCategory == "favoris") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CancelFavorite(
                                  favoriteBook: widget.book!,
                                  currentGroup: widget.currentGroup,
                                  currentUser: widget.currentUser,
                                )));
                  } else if (widget.sectionCategory == "lus") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CancelRead(
                                  readBook: widget.book!,
                                  currentGroup: widget.currentGroup,
                                  currentUser: widget.currentUser,
                                )));
                  }
                },
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).focusColor,
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _displayBookCard();
  }
}
