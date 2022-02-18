import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/sections/book_section/book_card.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';

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
  // late Future<List<BookModel>> books = DBFuture()
  //     .getContinueReadingBooks(widget.currentGroup.id!, widget.currentUser);

  // @override
  // void initState() {
  //   super.initState();

  //   _initSections().whenComplete(() {
  //     setState(() {});
  //   });
  // }

  // Future _initSections() async {
  //   if (widget.sectionCategory == "continuer") {
  //     books = DBFuture()
  //         .getContinueReadingBooks(widget.currentGroup.id!, widget.currentUser);
  //     nothingText = "Rien à lire pour l'instant !";
  //   } else if (widget.sectionCategory == "favoris") {
  //     books = DBFuture().getFavoriteBooks(widget.groupId, widget.currentUser);
  //     nothingText = "Aucun favori pour l'instant";
  //   }
  // }

  // @override
  // void didChangeDependencies() async {
  //   if (widget.sectionCategory == "continuer") {
  //     books = DBFuture()
  //         .getContinueReadingBooks(widget.currentGroup.id!, widget.currentUser);
  //     nothingText = "Rien à lire pour l'instant !";
  //   } else if (widget.sectionCategory == "favoris") {
  //     books = DBFuture().getFavoriteBooks(widget.groupId, widget.currentUser);
  //     nothingText = "Aucun favori pour l'instant";
  //   }

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookModel>>(
      stream: DBStream().getAllBooks(widget.currentGroup.id!),
      builder: (context, snapshot) {
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
            } else {
              return Container(
                padding: const EdgeInsets.only(top: 20),
                width: 350,
                height: 350,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container();
                    } else {
                      return BookCard(
                        book: snapshot.data![index - 1],
                        currentGroup: widget.currentGroup,
                        currentUser: widget.currentUser,
                      );
                    }
                  },
                ),
              );
            }
          }
        }
      },
    );
  }
}
