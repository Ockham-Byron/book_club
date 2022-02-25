import 'package:flutter/material.dart';

class BookHistory extends StatefulWidget {
  const BookHistory({Key? key}) : super(key: key);

  @override
  _BookHistoryState createState() => _BookHistoryState();
}

class _BookHistoryState extends State<BookHistory> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("book history"),
    );
  }
}
