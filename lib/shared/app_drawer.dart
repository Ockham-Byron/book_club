import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_profile.dart';
import 'package:book_club/screens/home/GroupHome/single_book_home.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;

  const AppDrawer({
    Key? key,
    required this.currentGroup,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget displayCircularAvatar() {
      if (currentUser.pictureUrl != "") {
        return CircularProfileAvatar(
          currentUser.pictureUrl!,
          showInitialTextAbovePicture: false,
        );
      } else {
        return CircularProfileAvatar(
          "https://digitalpainting.school/static/img/default_avatar.png",
          foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
          initialsText: Text(
            currentUser.pseudo![0].toUpperCase(),
            style: const TextStyle(
                fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          showInitialTextAbovePicture: true,
        );
      }
    }

    void _goToHome() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SingleBookHome(
                currentGroup: currentGroup,
                currentUser: currentUser,
              )));
    }

    void _goToGroupManage() {
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => GroupManageRef(
      //           currentGroup: currentGroup,
      //           currentUser: currentUser,
      //           currentBook: currentBook,
      //           authModel: authModel,
      //         )));
    }

    void _goToProfileManage() {
      //print("go to profile");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileAdmin(
                currentUser: currentUser,
                currentGroup: currentGroup,
                // currentBook: currentBook,
                // authModel: authModel,
              )));
    }

    _goToBooksHistory() {
      //print("go to book history");
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => BookHistory(
      //         groupId: currentGroup.id!,
      //         groupName: currentGroup.name!,
      //         currentGroup: currentGroup,
      //         currentUser: currentUser,
      //         currentBook: currentBook,
      //         authModel: authModel)));
    }

    String getUserPseudo() {
      String userPseudo;
      if (currentUser.pseudo == null) {
        userPseudo = "personne";
      } else {
        userPseudo = currentUser.pseudo!;
      }
      return "${userPseudo[0].toUpperCase()}${userPseudo.substring(1)}";
    }

    return Drawer(
      child: Column(
        // Important: Remove any padding from the ListView.

        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(width: 3, color: Theme.of(context).focusColor),
              ),
            ),
            child: Row(
              children: [
                displayCircularAvatar(),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  getUserPseudo(),
                  style: TextStyle(
                      color: Theme.of(context).focusColor, fontSize: 20),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KListTile(
                  iconData: Icons.houseboat,
                  title: "Accueil",
                  goTo: _goToHome,
                ),
                KListTile(
                  iconData: Icons.person,
                  title: "Profil",
                  goTo: _goToProfileManage,
                ),
                KListTile(
                  iconData: Icons.group,
                  title: "Groupe",
                  goTo: _goToGroupManage,
                ),
                KListTile(
                  iconData: Icons.auto_stories,
                  title: "Livres",
                  goTo: _goToBooksHistory,
                ),
                const SizedBox(
                  height: 50,
                ),
                Image.network(
                  "https://cdn.pixabay.com/photo/2018/04/24/11/32/book-3346785_1280.png",
                  fit: BoxFit.contain,
                  width: 250,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KListTile extends StatelessWidget {
  final IconData? iconData;
  final String? title;
  final VoidCallback? goTo;
  const KListTile({Key? key, this.iconData, this.title, this.goTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          iconData,
          color: Theme.of(context).focusColor,
        ),
        title: Text(
          title!,
          style: TextStyle(color: Theme.of(context).focusColor, fontSize: 20),
        ),
        onTap: goTo);
  }
}
