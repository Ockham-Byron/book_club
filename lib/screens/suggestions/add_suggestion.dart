import 'package:book_club/models/user_model.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/constraints.dart';
import 'package:book_club/shared/containers/shadow_container.dart';

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
  bool isChecked = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return Theme.of(context).focusColor;
    }
    return Theme.of(context).primaryColor;
  }
  //controllers

  final TextEditingController _suggestionInput = TextEditingController();

  //focusnodes
  FocusNode? fsuggestion;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return Center(
            child: SizedBox(
              height: mobileContainerMaxHeight,
              width: mobileMaxWidth,
              child: globalWidget(context),
            ),
          );
        } else {
          return globalWidget(context);
        }
      },
    );
  }

  Scaffold globalWidget(BuildContext context) {
    return Scaffold(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              Text(
                "Publier anonymement",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              DBFuture().addSuggestion(widget.currentUser.uid!, 0,
                  _suggestionInput.text, false, isChecked);
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
