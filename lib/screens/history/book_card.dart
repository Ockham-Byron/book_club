import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/review_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/create/add_review.dart';
import 'package:book_club/screens/edit/edit_book.dart';
import 'package:book_club/screens/history/book_detail.dart';
import 'package:book_club/screens/history/book_history.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/buttons/change_book_status_button.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:book_club/shared/display_services.dart';
import 'package:book_club/shared/loading.dart';

import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final BookModel book;
  final String? sectionCategory;
  const BookCard(
      {Key? key,
      required this.currentGroup,
      required this.currentUser,
      required this.book,
      this.sectionCategory})
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
          currentBook: widget.book,
          currentUser: widget.currentUser,
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    Widget _displayFavorite() {
      return StreamBuilder<ReviewModel>(
          stream: DBStream().getReviewData(widget.currentGroup.id!,
              widget.book.id!, widget.currentUser.uid!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else {
              if (snapshot.hasData) {
                ReviewModel _review = snapshot.data!;
                bool _isFavorited = _review.favorite!;
                bool _hasReadTheBook;
                if (widget.currentUser.uid == _review.reviewId) {
                  _hasReadTheBook = true;
                } else {
                  _hasReadTheBook = false;
                }
                void _toggleFavorite() {
                  setState(() {
                    if (_isFavorited = false) {
                      _isFavorited = true;
                    } else {
                      _isFavorited = false;
                    }
                  });
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          if (_hasReadTheBook == false) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => AddReview(
                                        currentGroup: widget.currentGroup,
                                        currentUser: widget.currentUser,
                                        bookId: widget.book.id!,
                                        fromRoute: BookHistory(
                                          currentGroup: widget.currentGroup,
                                          currentUser: widget.currentUser,
                                          title: "du groupe",
                                        ))),
                                (route) => false);
                          }
                        },
                        icon: Icon(Icons.check,
                            color: _hasReadTheBook == true
                                ? Theme.of(context).focusColor
                                : Colors.grey),
                        label: Text(
                          "Lu",
                          style: TextStyle(
                              color: _hasReadTheBook == true
                                  ? Theme.of(context).focusColor
                                  : Colors.grey),
                        )),
                    TextButton.icon(
                      onPressed: () {
                        if (_isFavorited) {
                          DBFuture().cancelFavoriteBook(widget.currentGroup.id!,
                              widget.book.id!, widget.currentUser.uid!);
                          _toggleFavorite();
                        } else {
                          DBFuture().favoriteBook(widget.currentGroup.id!,
                              widget.book.id!, widget.currentUser.uid!);
                          _toggleFavorite();
                        }
                      },
                      icon: Icon(Icons.favorite,
                          color: _isFavorited == true
                              ? Theme.of(context).focusColor
                              : Colors.grey),
                      label: Text(
                        "Favori",
                        style: TextStyle(
                            color: _isFavorited == true
                                ? Theme.of(context).focusColor
                                : Colors.grey),
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => AddReview(
                                    currentGroup: widget.currentGroup,
                                    currentUser: widget.currentUser,
                                    bookId: widget.book.id!,
                                    fromRoute: BookHistory(
                                      currentGroup: widget.currentGroup,
                                      currentUser: widget.currentUser,
                                      title: "du groupe",
                                    ))),
                          );
                        },
                        icon: const Icon(Icons.check, color: Colors.grey),
                        label: const Text(
                          "Lu",
                          style: TextStyle(color: Colors.grey),
                        )),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => AddReview(
                                  currentGroup: widget.currentGroup,
                                  currentUser: widget.currentUser,
                                  bookId: widget.book.id!,
                                  fromRoute: BookHistory(
                                    currentGroup: widget.currentGroup,
                                    currentUser: widget.currentUser,
                                    title: "du groupe",
                                  ))),
                        );
                      },
                      icon: const Icon(Icons.favorite, color: Colors.grey),
                      label: const Text(
                        "Favori",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                );
              }
            }
          });
    }

    return SizedBox(
      height: 300,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _goToBookDetail(context),
          child: ShadowContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 150,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(
                                  displayBookCoverUrl(widget.book)),
                              fit: BoxFit.fill),
                        ),
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
                      _displayEdit(widget.book),
                    ],
                  ),
                ),
                _displayFavorite(),
                ChangeBookStatusButton(
                    bookCard: widget,
                    context: context,
                    currentBook: widget.book)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
