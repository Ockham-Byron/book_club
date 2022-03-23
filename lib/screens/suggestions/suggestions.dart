import 'package:book_club/models/user_model.dart';
import 'package:flutter/material.dart';

class Suggestions extends StatefulWidget {
  final UserModel currentUser;

  const Suggestions({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
