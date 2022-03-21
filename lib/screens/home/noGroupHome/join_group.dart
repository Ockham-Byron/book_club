import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';

import 'package:book_club/services/db_future.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/appBars/home_app_bar.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:book_club/shared/custom_form_field.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';

import '../../../models/group_model.dart';
import 'create_group.dart';

class JoinGroup extends StatefulWidget {
  final UserModel userModel;
  const JoinGroup({Key? key, required this.userModel}) : super(key: key);

  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  List<GroupModel> allGroups = [];
  //key for the form's validation
  final _formKey = GlobalKey<FormState>();

  FocusNode? fid;

  //Alert popup wrong code
  Future<void> _showDialogWrongCode() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Aucun groupe correspondant à ce code"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    "Si on ne vous a pas communiqué de code de groupe et que voulez rejoindre le monde merveilleux des groupes de lecture, créez un groupe et invitez vos amis."),
                const Text(
                    "Si on vous a communiqué un code et que la mémoire vous revient, retournez à l'écran de connection"),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => CreateGroup(
                                      currentUser: widget.userModel,
                                    )),
                            (route) => false);
                      },
                      child: Text(
                        "Créer un groupe".toUpperCase(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Rejoindre un groupe".toUpperCase(),
                          style:
                              TextStyle(color: Theme.of(context).focusColor)),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('X',
                  style: TextStyle(color: Theme.of(context).focusColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _joinGroup(BuildContext context, String groupId) async {
    UserModel _currentUser = widget.userModel;

    await DBFuture().joinGroup(groupId: groupId, userId: _currentUser.uid!);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AppRoot(),
        ),
        (route) => false);
  }

  final TextEditingController _groupIdInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: BackgroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 255,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ShadowContainer(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomFormField(
                        hintText: "code du groupe",
                        iconData: Icons.group,
                        focusNode: fid,
                        textEditingController: _groupIdInput,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Merci d'indiquer le code du groupe";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<List<GroupModel>>(
                          stream: DBStream().getAllGroups(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Loading();
                            } else {
                              List<GroupModel> groups = snapshot.data!;
                              List<String> groupsId = [];
                              for (var group in groups) {
                                groupsId.add(group.id!);
                              }

                              return ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (groupsId.contains(_groupIdInput.text)) {
                                      _joinGroup(context, _groupIdInput.text);
                                    } else {
                                      _showDialogWrongCode();
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    "Joindre le groupe".toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              );
                            }
                          }),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Annuler".toUpperCase(),
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
