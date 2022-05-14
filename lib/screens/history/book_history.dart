import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/create/add_book.dart';
import 'package:book_club/screens/history/book_card.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/appBars/custom_app_bar.dart';
import 'package:book_club/shared/app_drawer.dart';
import 'package:book_club/shared/constraints.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:book_club/shared/loading.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';

class BookHistory extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final String? title;

  const BookHistory({
    Key? key,
    required this.currentGroup,
    required this.currentUser,
    required this.title,
  }) : super(key: key);

  @override
  _BookHistoryState createState() => _BookHistoryState();
}

class _BookHistoryState extends State<BookHistory> {
  bool withProfilePicture() {
    if (widget.currentUser.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

  Widget displayCircularAvatar() {
    if (withProfilePicture()) {
      return CircularProfileAvatar(
        widget.currentUser.pictureUrl!,
        showInitialTextAbovePicture: false,
      );
    } else {
      return CircularProfileAvatar(
        "https://digitalpainting.school/static/img/default_avatar.png",
        foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
        initialsText: Text(
          widget.currentUser.pseudo![0].toUpperCase(),
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        showInitialTextAbovePicture: true,
      );
    }
  }

  void _goToAddBook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBook(
          currentUser: widget.currentUser,
          currentGroup: widget.currentGroup,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return Center(
              child: SizedBox(
            height: mobileContainerMaxHeight,
            width: mobileMaxWidth,
            child: globalWidget(),
          ));
        } else {
          return globalWidget();
        }
      },
    );
  }

  Scaffold globalWidget() {
    return Scaffold(
      body: BackgroundContainer(
        child: StreamBuilder<List<BookModel>>(
          stream: DBStream().getAllBooks(
            widget.currentGroup.id!,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else {
              if (snapshot.data!.isNotEmpty) {
                List<BookModel> _allBooks = snapshot.data!;
                List<BookModel> _filteredBooks = [];
                if (widget.title == "du groupe") {
                  _filteredBooks = _allBooks;
                } else if (widget.title == "empruntables") {
                  _allBooks.forEach((BookModel book) {
                    if (book.isLendable == true && book.lenderId == null) {
                      _filteredBooks.add(book);
                    }
                  });
                } else if (widget.title == "en circulation") {
                  _allBooks.forEach((BookModel book) {
                    if (book.lenderId != null) {
                      _filteredBooks.add(book);
                    }
                  });
                } else if (widget.title == "que vous avez empruntés") {
                  _allBooks.forEach((BookModel book) {
                    if (book.lenderId == widget.currentUser.uid) {
                      _filteredBooks.add(book);
                    }
                  });
                } else if (widget.title == "que vous avez prêtés") {
                  _allBooks.forEach((BookModel book) {
                    if (book.ownerId == widget.currentUser.uid &&
                        book.lenderId != null) {
                      _filteredBooks.add(book);
                    }
                  });
                } else if (widget.title == "à continuer") {
                  _allBooks.forEach((BookModel book) {
                    if (widget.currentUser.readBooks!.contains(book.id) ||
                        widget.currentUser.dontWantToReadBooks!
                            .contains(book.id)) {
                      _filteredBooks.add(book);
                    }
                  });
                } else if (widget.title == "favoris") {
                  _allBooks.forEach((BookModel book) {
                    if (widget.currentUser.favoriteBooks!.contains(book.id)) {
                      _filteredBooks.add(book);
                    }
                  });
                } else if (widget.title == "lus") {
                  _allBooks.forEach((BookModel book) {
                    if (widget.currentUser.readBooks!.contains(book.id)) {
                      _filteredBooks.add(book);
                    }
                  });
                }

                return ListView.builder(
                    itemCount: _filteredBooks.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            CustomAppBar(
                                currentUser: widget.currentUser,
                                currentGroup: widget.currentGroup),
                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Livres " + widget.title!,
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: BookCard(
                              currentGroup: widget.currentGroup,
                              currentUser: widget.currentUser,
                              book: _filteredBooks[index - 1],
                              sectionCategory: widget.title,
                            ));
                      }
                    });
              } else {
                //Si pas de critique
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 180.0),
                  child: ShadowContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              right: 50,
                            ),
                            child: Image.network(
                                "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Il n'y a pas encore de livre dans ce groupe ;(",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                            onPressed: () => _goToAddBook(),
                            child: const Text("Ajouter le premier livre"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
      drawer: AppDrawer(
        currentGroup: widget.currentGroup,
        currentUser: widget.currentUser,
      ),
    );
  }
}
