import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/review_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/history/book_detail.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/constraints.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

import '../../shared/buttons/cancel_button.dart';
import '../../shared/containers/background_container.dart';

class EditReview extends StatefulWidget {
  final GroupModel currentGroup;
  final BookModel book;
  final ReviewModel currentReview;
  final UserModel currentUser;

  const EditReview({
    Key? key,
    required this.currentGroup,
    required this.book,
    required this.currentReview,
    required this.currentUser,
  }) : super(key: key);

  @override
  _EditReviewState createState() => _EditReviewState();
}

class _EditReviewState extends State<EditReview> {
  bool? initialFavorite;
  String? initialReview;
  int? initialRating;
  int _bookRatingInput = 1;
  bool _favoriteInput = false;

  @override
  void initState() {
    initialFavorite = widget.currentReview.favorite;
    initialReview = widget.currentReview.review;
    initialRating = widget.currentReview.rating;

    _bookReviewInput.text = initialReview!;

    _bookRatingInput = initialRating!;
    _favoriteInput = initialFavorite!;

    super.initState();
  }

  final TextEditingController _bookReviewInput = TextEditingController();

  void _editReview(
    String userId,
    String groupId,
    String bookId,
    String review,
    bool favorite,
    int rating,
  ) async {
    String _returnString;

    _returnString = await DBFuture().editReview(
        groupId: groupId,
        bookId: bookId,
        userId: userId,
        review: review,
        rating: rating,
        favorite: favorite);

    if (_favoriteInput != widget.currentReview.favorite) {
      if (_favoriteInput == true) {
        DBFuture().favoriteBook(groupId, bookId, widget.currentUser.uid!);
      } else {
        DBFuture().cancelFavoriteBook(groupId, bookId, widget.currentUser.uid!);
      }
    }

    if (_returnString == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BookDetail(
                currentGroup: widget.currentGroup,
                currentBook: widget.book,
                currentUser: widget.currentUser,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return ComputerLayout(globalWidget(context));
        } else {
          return globalWidget(context);
        }
      },
    );
  }

  Scaffold globalWidget(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: ListView(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ShadowContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Evaluez le livre de 1 à 10",
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                    DropdownButton<int>(
                        value: _bookRatingInput,
                        icon: Icon(
                          Icons.arrow_downward,
                          color: Theme.of(context).primaryColor,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                        underline: Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 2,
                          color: Theme.of(context).focusColor,
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            _bookRatingInput = newValue!;
                          });
                        },
                        items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList())
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ShadowContainer(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _bookReviewInput,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).canvasColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon(
                          Icons.question_answer,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: "Votre avis",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ShadowContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Ce livre fait-il partie de vos favoris ?",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 20),
                    FavoriteButton(
                      iconColor: Theme.of(context).focusColor,
                      isFavorite: initialFavorite,
                      valueChanged: (_isFavorite) {
                        if (_isFavorite == false) {
                          _favoriteInput = false;
                        } else {
                          _favoriteInput = true;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ShadowContainer(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _editReview(
                              widget.currentUser.uid!,
                              widget.currentGroup.id!,
                              widget.book.id!,
                              _bookReviewInput.text,
                              _favoriteInput,
                              _bookRatingInput);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            "Modifier".toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    const CancelButton(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
