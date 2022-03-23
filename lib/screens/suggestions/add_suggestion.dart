import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/suggestion_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

class AddSuggestion extends StatefulWidget {
  final UserModel currentUser;

  const AddSuggestion({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _AddSuggestionState createState() => _AddSuggestionState();
}

class _AddSuggestionState extends State<AddSuggestion> {
  final reviewKey = GlobalKey<ScaffoldState>();
  int _dropdownValue = 1;
  bool favorite = false;

  //controllers

  final TextEditingController _suggestionInput = TextEditingController();

  //focusnodes
  FocusNode? fsuggestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: reviewKey,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Quelle est votre suggestion ?",
            style: TextStyle(
              fontSize: 20,
              //color: Theme.of(context).focusColor
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ShadowContainer(
              child: Column(
                children: [
                  TextFormField(
                    controller: _suggestionInput,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: "Votre suggestion",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              DBFuture().addSuggestion(
                  widget.currentUser.uid!, 0, _suggestionInput.text, false);
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Envoyer votre suggestion".toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Annuler".toUpperCase(),
                style: TextStyle(color: Theme.of(context).focusColor),
              ))
        ],
      ),
    );
  }
}
