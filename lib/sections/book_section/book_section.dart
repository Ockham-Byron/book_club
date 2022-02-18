import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/sections/book_section/book_card.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookModel>>(
      stream: DBStream().getAllBooks(widget.currentGroup.id!),
      builder: (context, snapshot) {
        if (widget.sectionCategory == "favoris") {
          nothingText = "pas de favoris";
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("waiting");
          return const Loading();
        } else {
          if (snapshot.hasError) {
            print("y a un problème");
            return const Loading();
          } else {
            if (!snapshot.hasData) {
              print("pas de data");
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
                    //print("déjà lu");
                  } else {
                    selectedBooks.add(book);
                  }
                }
                nothingText = "Vous avez tout lu";
              }
              if (widget.sectionCategory == "favoris") {
                for (var book in allBooks) {
                  if (widget.currentUser.favoriteBooks!.contains(book.id)) {
                    selectedBooks.add(book);
                  }
                }
                nothingText = "aucun favori";
              }

              if (selectedBooks.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: 350,
                  height: 350,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedBooks.length + 1,
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
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    nothingText,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
