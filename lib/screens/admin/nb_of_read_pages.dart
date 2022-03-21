import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/loading.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';

class ReadPages extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  const ReadPages(
      {Key? key, required this.currentGroup, required this.currentUser})
      : super(key: key);

  @override
  State<ReadPages> createState() => _ReadPagesState();
}

class _ReadPagesState extends State<ReadPages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookModel>>(
        stream: DBStream().getAllBooks(widget.currentGroup.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            int nbOfReadPages = 0;
            List<BookModel> allBooks = snapshot.data!;
            List<BookModel> readBooks = [];
            List<int> readBooksPages = [];
            for (var book in allBooks) {
              if (widget.currentUser.readBooks!.contains(book.id)) {
                readBooks.add(book);
              }
            }
            for (BookModel book in readBooks) {
              readBooksPages.add(book.length!);
            }
            nbOfReadPages = readBooksPages.sum;
            return Text(
              nbOfReadPages.toString(),
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.red[300],
                  fontWeight: FontWeight.w700),
            );
          }
        });
  }
}
