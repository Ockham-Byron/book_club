import 'package:book_club/models/group_model.dart';
import 'package:book_club/screens/admin/member_change.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/display_services.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/user_model.dart';
import '../../shared/appBars/custom_app_bar.dart';
import '../../shared/app_drawer.dart';

class ChangeLeader extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  const ChangeLeader(
      {Key? key, required this.currentGroup, required this.currentUser})
      : super(key: key);

  @override
  State<ChangeLeader> createState() => _ChangeLeaderState();
}

class _ChangeLeaderState extends State<ChangeLeader> {
  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(
        ClipboardData(text: getGroupId(widget.currentGroup)));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Copié dans le presse papier")));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GroupModel>(
        stream: DBStream().getGroupData(widget.currentGroup.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            GroupModel _currentGroup = snapshot.data!;
            if (_currentGroup.members!.length == 1) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          right: 50,
                        ),
                        child: Image.network(
                            "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Il n'y a pas d'autre membre que vous dans ce groupe ;(",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        "Invitez des passionnés de lecture à vous rejoindre",
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: 350,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor)),
                        child: Column(
                          children: [
                            const Text(
                              "Id du groupe à partager aux nouveaux membres",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getGroupId(_currentGroup),
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    child: Icon(
                                      Icons.copy,
                                      color: Theme.of(context).focusColor,
                                    ),
                                    onTap: _copyToClipboard,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "Revenir à la page du groupe",
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: BackgroundContainer(
                  child: ListView(
                    children: [
                      CustomAppBar(
                          currentUser: widget.currentUser,
                          currentGroup: _currentGroup),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Text(
                                "Choisissez la nouvelle personne à qui confier l'administration du groupe.",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            StreamBuilder<List<UserModel>>(
                                stream: DBStream().getAllUsers(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Loading();
                                  } else {
                                    List<UserModel> allUsers = snapshot.data!;
                                    List<UserModel> members = [];
                                    for (var user in allUsers) {
                                      if (_currentGroup.members!
                                          .contains(user.uid)) {
                                        members.add(user);
                                      }
                                    }
                                    return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: members.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == 0) {
                                            return Container();
                                          } else {
                                            return MemberChange(
                                                user: members[index - 1],
                                                currentUser: widget.currentUser,
                                                currentGroup: _currentGroup);
                                          }
                                        });
                                  }
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                drawer: AppDrawer(
                  currentGroup: _currentGroup,
                  currentUser: widget.currentUser,
                ),
              );
            }
          }
        });
  }
}
