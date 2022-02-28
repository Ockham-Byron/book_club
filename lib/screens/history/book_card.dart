import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/edit/edit_book.dart';
import 'package:book_club/screens/history/book_detail.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final BookModel book;
  const BookCard(
      {Key? key,
      required this.currentGroup,
      required this.currentUser,
      required this.book})
      : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  // bool _isFavorited = false;

  // void _toggleFavorite() {
  //   setState(() {
  //     if (_isFavorited = false) {
  //       _isFavorited = true;
  //     } else {
  //       _isFavorited = false;
  //     }
  //   });
  // }

  String _currentBookCoverUrl() {
    String currentBookCoverUrl;

    if (widget.book.cover == "") {
      currentBookCoverUrl =
          "https://www.azendportafolio.com/static/img/not-found.png";
    } else {
      currentBookCoverUrl = widget.book.cover!;
    }

    return currentBookCoverUrl;
  }

  // String _nbOfPages() {
  //   String nbOfPages;

  //   if (widget.book!.length != null) {
  //     nbOfPages = widget.book!.length!.toString() + " pages";
  //   } else {
  //     nbOfPages = "Nombre de pages inconnu";
  //   }

  //   return nbOfPages;
  // }

  void _goToBookDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetail(
          currentGroup: widget.currentGroup,
          currentBook: widget.book,
          currentUser: widget.currentUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Widget _displayFavorite() {
    //   return TextButton.icon(
    //     onPressed: () {
    //       if (widget.currentUser.favoriteBooks!.contains(widget.book!.id)) {
    //         DBFuture().cancelFavoriteBook(
    //             widget.groupId!, widget.book!.id!, widget.currentUser.uid!);
    //         _toggleFavorite();
    //       } else {
    //         DBFuture().favoriteBook(
    //             widget.groupId!, widget.book!.id!, widget.currentUser.uid!);
    //         _toggleFavorite();
    //       }
    //     },
    //     icon: Icon(Icons.favorite,
    //         color: _isFavorited == true
    //             ? Theme.of(context).primaryColor
    //             : Colors.grey),
    //     label: Text(
    //       "Favori",
    //       style: TextStyle(
    //           color: _isFavorited == true
    //               ? Theme.of(context).primaryColor
    //               : Colors.grey),
    //     ),
    //   );
    // }

    return SizedBox(
      height: 250,
      child: GestureDetector(
        onTap: () => _goToBookDetail(context),
        child: ShadowContainer(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      child: Image.network(_currentBookCoverUrl()),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.book.title ?? "Pas de titre",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).focusColor),
                          ),
                          Text(
                            widget.book.author ?? "Pas d'auteur",
                            style: const TextStyle(
                                fontSize: 20, color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(widget.book.length.toString() + " pages")
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
                                      currentBook: widget.book,
                                      currentUser: widget.currentUser,
                                      fromScreen: "fromHistory",
                                    )));
                          },
                          child: Text(
                            "MODIFIER",
                            style:
                                TextStyle(color: Theme.of(context).focusColor),
                          )),
                    )
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     TextButton.icon(
              //         onPressed: () {},
              //         icon: Icon(
              //           Icons.check,
              //         ),
              //         label: Text("Lu")),
              //     _displayFavorite(),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
