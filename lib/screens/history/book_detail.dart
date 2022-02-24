import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/review_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/create/add_review.dart';
import 'package:book_club/screens/history/review_card.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/appBars/custom_app_bar.dart';
import 'package:book_club/shared/buttons/finish_button.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/loading.dart';

import 'package:flutter/material.dart';

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
  // late Future<List<ReviewModel>> reviews = DBFuture()
  //     .getReviewHistory(widget.currentGroup, widget.groupId, widget.bookId);
  bool _hasReadTheBook = false;
  late int nbOfReviews = 0;
  late int nbOfFavorites = 0;

  // @override
  // void initState() {
  //   super.initState();

  //   _getNbOfReviews().whenComplete(() {
  //     setState(() {});
  //   });
  // }

  // Future _getNbOfReviews() async {
  //   nbOfReviews =
  //       await DBFuture().getNbOfReviews(widget.groupId, widget.bookId);
  //   nbOfFavorites =
  //       await DBFuture().getNbOfFavorites(widget.groupId, widget.bookId);
  // }

  // @override
  // void didChangeDependencies() async {
  //   reviews = DBFuture()
  //       .getReviewHistory(widget.currentGroup, widget.groupId, widget.bookId);
  //   //check if the user is done with book
  //   if (widget.currentGroup.currentBookId != null) {
  //     if (await DBFuture().isUserDoneWithBook(
  //         widget.currentGroup.id!, widget.bookId, widget.currentUser.uid!)) {
  //       _doneWithBook = true;
  //     } else {
  //       _doneWithBook = false;
  //     }
  //   }

  //   super.didChangeDependencies();
  // }

  // Widget displayCircularAvatar() {
  //   if (withProfilePicture()) {
  //     return CircularProfileAvatar(
  //       widget.currentUser.pictureUrl,
  //       showInitialTextAbovePicture: false,
  //     );
  //   } else {
  //     return CircularProfileAvatar(
  //       "https://digitalpainting.school/static/img/default_avatar.png",
  //       foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
  //       initialsText: Text(
  //         widget.currentUser.pseudo![0].toUpperCase(),
  //         style: TextStyle(
  //             fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
  //       ),
  //       showInitialTextAbovePicture: true,
  //     );
  //   }
  // }

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

  String _currentBookCoverUrl() {
    String currentBookCoverUrl;

    if (widget.currentBook.cover == "") {
      currentBookCoverUrl =
          "https://www.azendportafolio.com/static/img/not-found.png";
    } else {
      currentBookCoverUrl = widget.currentBook.cover!;
    }

    return currentBookCoverUrl;
  }

  Widget _displayBookInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(_currentBookCoverUrl()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.currentBook.title ?? "Pas de titre",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor),
              ),
              Text(
                widget.currentBook.author ?? "Pas d'auteur",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _displayAddReview() {
  //   if (!_doneWithBook) {
  //     return Padding(
  //       padding: const EdgeInsets.all(20.0),
  //       child: ElevatedButton(
  //           onPressed: () => _goToReview(),
  //           child:
  //               const Text("Indique que, toi, aussi, tu as terminé ce livre")),
  //     );
  //   } else {
  //     return const Text("");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: StreamBuilder<List<ReviewModel>>(
          stream: DBStream()
              .getAllReviews(widget.currentGroup.id!, widget.currentBook.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("waiting");
              return Loading();
            } else {
              if (snapshot.data!.isNotEmpty) {
                List<ReviewModel> reviews = snapshot.data!;
                return ListView.builder(
                  itemCount: reviews.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Column(
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
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
                                      //ajouter nombre de reviews
                                      nbOfReviews.toString(),

                                      style: kSubtitleStyle,
                                    ),
                                    Text(
                                      //ajouter note
                                      nbOfFavorites.toString(),

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
                                const Text(
                                  "Avis du groupe",
                                  style: TextStyle(fontSize: 30),
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
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: ReviewCard(
                          review: reviews[index - 1],
                          currentUser: widget.currentUser,
                          currentGroup: widget.currentGroup,
                          book: widget.currentBook,
                        ),
                      );
                    }
                  },
                );
              } else {
                //Si pas de critique
                return Column(
                  children: [
                    CustomAppBar(
                        currentUser: widget.currentUser,
                        currentGroup: widget.currentGroup),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 300,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "Il n'y a pas encore de critique pour ce livre ;(",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 100),
                            ElevatedButton(
                              onPressed: () => _goToReview(),
                              child: const Text("Ajouter la première critique"),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
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
