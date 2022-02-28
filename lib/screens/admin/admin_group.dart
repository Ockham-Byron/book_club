import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/member_card.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/appBars/custom_app_bar.dart';
import 'package:book_club/shared/app_drawer.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/loading.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../edit/edit_groupname.dart';

class AdminGroup extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;

  const AdminGroup({
    Key? key,
    required this.currentGroup,
    required this.currentUser,
  }) : super(key: key);

  @override
  _AdminGroupState createState() => _AdminGroupState();
}

class _AdminGroupState extends State<AdminGroup> {
  String? _getGroupId() {
    String? groupId;
    if (widget.currentGroup.id != null) {
      groupId = widget.currentGroup.id;
    } else {
      groupId = "Id inconnu, ce qui est très étrange";
    }
    return groupId;
  }

  bool withProfilePicture() {
    if (widget.currentUser.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

  Widget displayCircularAvatar() {
    if (withProfilePicture()) {
      return CircularProfileAvatar(
        widget.currentUser.pictureUrl!,
        showInitialTextAbovePicture: false,
      );
    } else {
      return CircularProfileAvatar(
        "https://digitalpainting.school/static/img/default_avatar.png",
        foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
        initialsText: Text(
          widget.currentUser.pseudo![0].toUpperCase(),
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        showInitialTextAbovePicture: true,
      );
    }
  }

  Widget displayEditButton() {
    if (widget.currentUser.uid == widget.currentGroup.leader) {
      return StreamBuilder<GroupModel>(
          stream: DBStream().getGroupData(widget.currentGroup.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              GroupModel _currentGroup = snapshot.data!;
              return TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditGroupName(
                            currentGroup: _currentGroup,
                            currentUser: widget.currentUser,
                          )));
                },
                child: Text(
                  "MODIFIER",
                  style: TextStyle(color: Theme.of(context).focusColor),
                ),
              );
            }
          });
    } else {
      return Container(
        height: 50,
      );
    }
  }

  int getNbGroupMembers() {
    int groupMembers;
    if (widget.currentGroup.members != null) {
      groupMembers = widget.currentGroup.members!.length;
    } else {
      groupMembers = 0;
    }
    return groupMembers;
  }

  void _goToHistory() async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => BookHistory(
    //       groupId: widget.currentGroup.id!,
    //       groupName: widget.currentGroup.name!,
    //       currentGroup: widget.currentGroup,
    //       currentUser: widget.currentUser,
    //       currentBook: widget.currentBook,
    //       authModel: widget.authModel,
    //     ),
    //   ),
    // );
  }

  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _getGroupId()));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Copié dans le presse papier")));
  }

  List<String>? getGroupMembers() {
    List<String>? groupMembers;
    if (widget.currentGroup.members!.isEmpty) {
      groupMembers = [widget.currentGroup.leader!];
    } else {
      groupMembers = widget.currentGroup.members!;
    }
    return groupMembers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: ListView(
          children: [
            CustomAppBar(
                currentUser: widget.currentUser,
                currentGroup: widget.currentGroup),
            Container(
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
                  displayEditButton(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text(
                        "LIVRES",
                        style: kTitleStyle,
                      ),
                      Text(
                        "MEMBRES",
                        style: kTitleStyle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StreamBuilder<List<BookModel>>(
                          stream:
                              DBStream().getAllBooks(widget.currentGroup.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Loading();
                            } else {
                              List<BookModel> books = snapshot.data!;
                              return Text(
                                books.length.toString(),
                                //getGroupBooks().toString(),
                                style: kSubtitleStyle,
                              );
                            }
                          }),
                      Text(
                        getNbGroupMembers().toString(),
                        style: kSubtitleStyle,
                      ),
                    ],
                  ),
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Theme.of(context).primaryColor)),
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
                              _getGroupId()!,
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.copy,
                                color: Theme.of(context).focusColor,
                              ),
                              onTap: _copyToClipboard,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _goToHistory,
                      child: const Text("Voir tous les livres du groupe")),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Membres du groupe",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
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
                            if (widget.currentGroup.members!
                                .contains(user.uid)) {
                              members.add(user);
                            }
                          }
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: members.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  return Container();
                                } else {
                                  return MemberCard(
                                      user: members[index - 1],
                                      currentGroup: widget.currentGroup);
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
        currentGroup: widget.currentGroup,
        currentUser: widget.currentUser,
      ),
    );
  }
}

const kTitleStyle = TextStyle(
  fontSize: 20,
  color: Colors.grey,
  fontWeight: FontWeight.w700,
);

final kSubtitleStyle = TextStyle(
  fontSize: 26,
  color: Colors.red[300],
  fontWeight: FontWeight.w700,
);
