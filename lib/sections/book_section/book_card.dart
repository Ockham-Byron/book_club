import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/history/book_detail.dart';
import 'package:book_club/sections/book_section/cancel_favorite.dart';
import 'package:book_club/sections/book_section/cancel_read.dart';
import 'package:book_club/sections/book_section/finish_book.dart';
import 'package:book_club/shared/display_services.dart';
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
                    image: NetworkImage(displayBookCoverUrl(widget.book!)),
                    fit: BoxFit.fill),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.book!.title ?? "Pas de titre",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 15, color: Theme.of(context).focusColor),
            ),
            Text(
              widget.book!.author ?? "Pas d'auteur",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            CancelButton(widget: widget, context: context)
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

class CancelButton extends StatelessWidget {
  const CancelButton({
    Key? key,
    required this.widget,
    required this.context,
  }) : super(key: key);

  final BookCard widget;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    if (widget.sectionCategory == "empruntables" &&
        widget.book!.ownerId != widget.currentUser.uid) {
      print("empruntable");
      return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.add_task,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "emprunter",
      );
    }
    if (widget.sectionCategory == "empruntables" &&
        widget.book!.ownerId == widget.currentUser.uid) {
      print(widget.book!.ownerId);
      return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.cancel,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "je ne prête plus ce livre",
      );
    } else if (widget.sectionCategory == "en circulation" &&
        widget.book!.ownerId != widget.currentUser.uid) {
      return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.bookmark_add,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "liste d'attente",
      );
    } else if (widget.sectionCategory == "en circulation" &&
        widget.book!.ownerId == widget.currentUser.uid) {
      return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.cable,
          color: Theme.of(context).focusColor,
        ),
        tooltip: "modifier l'emprunteur",
      );
    } else if (widget.sectionCategory == "que vous avez prêtés") {
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
          ));
    }
  }
}
