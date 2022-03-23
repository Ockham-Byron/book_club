import 'package:book_club/models/suggestion_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:flutter/material.dart';

class SuggestionCard extends StatefulWidget {
  final SuggestionModel suggestion;
  const SuggestionCard({
    Key? key,
    required this.suggestion,
  }) : super(key: key);

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [Text(widget.suggestion.suggestion!)],
      ),
    );
  }
}
