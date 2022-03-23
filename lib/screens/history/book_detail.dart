import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/review_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/create/add_review.dart';
import 'package:book_club/screens/edit/edit_book.dart';
import 'package:book_club/screens/history/review_card.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/appBars/custom_app_bar.dart';
import 'package:book_club/shared/app_drawer.dart';
import 'package:book_club/shared/buttons/finish_button.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/loading.dart';

import 'package:flutter/material.dart';

import '../../shared/display_services.dart';

class BookDetail extends StatefulWidget {
  final UserModel currentUser;

  final BookModel currentBook;
  final GroupModel currentGroup;
  const BookDetail({
    Key? key,
    required this.currentGroup,
    required this.currentBook,
    required this.currentUser,
  }) : super(key: key);

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  void _goToReview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddReview(
          currentGroup: widget.currentGroup,
          bookId: widget.currentBook.id!,
          currentUser: widget.currentUser,
          fromRoute: BookDetail(
            currentGroup: widget.currentGroup,
            currentBook: widget.currentBook,
            currentUser: widget.currentUser,
          ),
        ),
      ),
    );
  }

  Widget _displayBookInfo() {
    return StreamBuilder<BookModel>(
        stream: DBStream().getBookData(
            groupId: widget.currentGroup.id!, bookId: widget.currentBook.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            BookModel _currentBook = snapshot.data!;
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(
                                  displayBookCoverUrl(_currentBook)),
                              fit: BoxFit.fill),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentBook.title ?? "Pas de titre",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).focusColor),
                          ),
                          Text(
                            _currentBook.author ?? "Pas d'auteur",
                            style: const TextStyle(
                                fontSize: 20, color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            _currentBook.length.toString() + " pages",
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditBook(
                              currentGroup: widget.currentGroup,
                              currentBook: _currentBook,
                              currentUser: widget.currentUser,
                              fromScreen: "book_detail"),
                        )),
                    child: Text(
                      "Modifier".toUpperCase(),
                      style: TextStyle(color: Theme.of(context).focusColor),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Livre proposé par "),
                    StreamBuilder<UserModel>(
                        stream:
                            DBStream().getUserData(_currentBook.submittedBy!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Loading();
                          } else {
                            UserModel _user = snapshot.data!;
                            return Text(
                              "${_user.pseudo![0].toUpperCase()}${_user.pseudo!.substring(1)}",
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            );
                          }
                        })
                  ],
                ),
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: ListView(
          children: [
            CustomAppBar(
                currentUser: widget.currentUser,
                currentGroup: widget.currentGroup),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  _displayBookInfo(),
                  StreamBuilder<List<ReviewModel>>(
                      stream: DBStream().getAllReviews(
                          widget.currentGroup.id!, widget.currentBook.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Loading();
                        } else {
                          if (snapshot.data!.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    "Il n'y a pas encore de critique pour ce livre ;(",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () => _goToReview(),
                                  child: const Text(
                                      "Ajouter la première critique"),
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            );
                          } else {
                            List<ReviewModel> _reviews = snapshot.data!;
                            String nbOfFavorites() {
                              int nbOfFavorites = 0;
                              for (var item in _reviews) {
                                if (item.favorite == true) {
                                  nbOfFavorites += 1;
                                }
                              }

                              return nbOfFavorites.toString();
                            }

                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _reviews.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == 0) {
                                    return Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: const [
                                            Text(
                                              "LU PAR",
                                              style: kTitleStyle,
                                            ),
                                            Text(
                                              "FAVORIS",
                                              style: kTitleStyle,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              _reviews.length.toString(),
                                              style: kSubtitleStyle,
                                            ),
                                            Text(
                                              nbOfFavorites(),
                                              style: kSubtitleStyle,
                                            ),
                                          ],
                                        ),
                                        FinishButton(
                                            currentGroup: widget.currentGroup,
                                            currentUser: widget.currentUser,
                                            book: widget.currentBook,
                                            bookId: widget.currentBook.id!,
                                            fromScreen: "bookDetail"),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Text(
                                          "Avis du groupe",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, bottom: 20),
                                          child: const Text(
                                            "Pour info, il n'y a pas de note moyenne, car lorsque l'on a la tête dans le frigo et les pieds dans le four, notre température ne peut être qualifiée de tiède...",
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return ReviewCard(
                                      review: _reviews[index - 1],
                                      currentUser: widget.currentUser,
                                      currentGroup: widget.currentGroup,
                                      book: widget.currentBook,
                                    );
                                  }
                                });
                          }
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(
        currentGroup: widget.currentGroup,
        currentUser: widget.currentUser,
      ),
    );
  }
}

const kTitleStyle = TextStyle(
  fontSize: 20,
  color: Colors.grey,
  fontWeight: FontWeight.w700,
);

final kSubtitleStyle = TextStyle(
  fontSize: 26,
  color: Colors.red[300],
  fontWeight: FontWeight.w700,
);
