import 'dart:ffi';

import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_group.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:flutter/material.dart';

import '../../models/group_model.dart';
import '../../shared/custom_form_field.dart';

class EditGroupName extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  const EditGroupName(
      {Key? key, required this.currentGroup, required this.currentUser})
      : super(key: key);

  @override
  _EditGroupNameState createState() => _EditGroupNameState();
}

class _EditGroupNameState extends State<EditGroupName> {
  //key for the form's validation
  final _formKey = GlobalKey<FormState>();

  //focus
  FocusNode? fgrname;

  //initial data
  String? initialName;

  @override
  void initState() {
    initialName = widget.currentGroup.name!;
    _groupNameInput.text = initialName!;
    super.initState();
  }

  void _editGroupName(String groupId, String groupName) async {
    await DBFuture().editGroupName(groupId: groupId, groupName: groupName);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AdminGroup(
            currentGroup: widget.currentGroup,
            currentUser: widget.currentUser)));
  }

  final TextEditingController _groupNameInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: Column(children: [
            const SizedBox(
              height: 250,
            ),
            ShadowContainer(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomFormField(
                      focusNode: fgrname,
                      textEditingController: _groupNameInput,
                      iconData: Icons.group,
                      hintText: "Nom du groupe",
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Merci d'indiquer un nom de groupe";
                        } else {
                          return null;
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _editGroupName(
                              widget.currentGroup.id!, _groupNameInput.text);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "Modifier".toUpperCase(),
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
          ]),
        ),
      ),
    );
  }
}
