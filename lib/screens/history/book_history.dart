import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/create/add_book.dart';
import 'package:book_club/screens/history/book_card.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/appBars/custom_app_bar.dart';
import 'package:book_club/shared/app_drawer.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:book_club/shared/loading.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';

class BookHistory extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;

  const BookHistory({
    Key? key,
    required this.currentGroup,
    required this.currentUser,
  }) : super(key: key);

  @override
  _BookHistoryState createState() => _BookHistoryState();
}

class _BookHistoryState extends State<BookHistory> {
  String _displayGroupName() {
    if (widget.currentGroup.name != null) {
      return widget.currentGroup.name!;
    } else {
      return "Groupe sans nom";
    }
  }

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
                List<BookModel> _books = snapshot.data!;
                return ListView.builder(
                    itemCount: _books.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            CustomAppBar(
                                currentUser: widget.currentUser,
                                currentGroup: widget.currentGroup),
                            Column(
                              children: const [
                                SizedBox(
                                  height: 10,
                                ),
                                // Add filter
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
                              book: _books[index - 1],
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
