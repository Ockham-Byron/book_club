import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';

import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/appBars/home_app_bar.dart';
import 'package:book_club/shared/constraints.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:flutter/material.dart';

import '../../../shared/custom_form_field.dart';

class CreateGroup extends StatefulWidget {
  final UserModel currentUser;
  const CreateGroup({Key? key, required this.currentUser}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  //key for the form's validation
  final _formKey = GlobalKey<FormState>();

  FocusNode? fgrname;

  void _createGroup(String groupName, UserModel user) async {
    String _returnString;

    _returnString = await DBFuture().createGroup(groupName, user);

    if (_returnString == "success") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AppRoot()));
    }
  }

  final TextEditingController _groupNameInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return Center(
              child: SizedBox(
                  height: mobileContainerMaxHeight,
                  width: mobileMaxWidth,
                  child: globalLayout(context)));
        } else {
          return globalLayout(context);
        }
      },
    );
  }

  Scaffold globalLayout(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: BackgroundContainer(
        child: Center(
          child: Container(
            height: 250,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ShadowContainer(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomFormField(
                      hintText: "Nom du groupe",
                      iconData: Icons.group,
                      focusNode: fgrname,
                      textEditingController: _groupNameInput,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Merci de donner un nom au groupe";
                        } else if (val.length < 4) {
                          return "Le nom doit comporter au moins 4 caractères";
                        } else {
                          return null;
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          UserModel currentUser = widget.currentUser;

                          _createGroup(_groupNameInput.text, currentUser);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Créez le groupe".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Annuler".toUpperCase(),
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
