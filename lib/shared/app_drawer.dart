import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_group.dart';
import 'package:book_club/screens/admin/admin_profile.dart';
import 'package:book_club/screens/history/book_history.dart';
import 'package:book_club/screens/home/GroupHome/single_book_home.dart';
import 'package:book_club/screens/legal/legal.dart';
import 'package:book_club/screens/suggestions/suggestions.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';

import '../screens/donation/donate.dart';
import '../screens/home/GroupHome/group_home.dart';
import '../screens/home/GroupHome/several_books_home.dart';

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
      if (currentGroup.isSingleBookGroup == false) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SeveralBooksHome(
                  currentGroup: currentGroup,
                  currentUser: currentUser,
                )));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SingleBookHome(
                  currentGroup: currentGroup,
                  currentUser: currentUser,
                )));
      }
    }

    void _goToGroupManage() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AdminGroup(
                currentGroup: currentGroup,
                currentUser: currentUser,
              )));
    }

    void _goToProfileManage() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileAdmin(
                currentUser: currentUser,
                currentGroup: currentGroup,
              )));
    }

    void _goToBooksHistory() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BookHistory(
                currentGroup: currentGroup,
                currentUser: currentUser,
                title: "du groupe",
              )));
    }

    void _goToDonation() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Donate(
                currentGroup: currentGroup,
                currentUser: currentUser,
              )));
    }

    void _goToSuggestion() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Suggestions(
                currentUser: currentUser,
              )));
    }

    void _goToLegal() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Legal()));
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
      child: ListView(
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
          SizedBox(
            height: 600,
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
                ListTile(
                    leading: Icon(Icons.coffee,
                        color: Theme.of(context).shadowColor),
                    title: Text(
                      "Offrez-moi un café",
                      style: TextStyle(
                          color: Theme.of(context).shadowColor, fontSize: 20),
                    ),
                    onTap: () => _goToDonation()),
                ListTile(
                    leading: Icon(Icons.telegram,
                        color: Theme.of(context).shadowColor),
                    title: Text(
                      "Vos suggestions pour améliorer l'app",
                      style: TextStyle(
                          color: Theme.of(context).shadowColor, fontSize: 20),
                    ),
                    onTap: () => _goToSuggestion()),
                ListTile(
                    leading: const Icon(Icons.adjust, color: Colors.black),
                    title: const Text(
                      "A propos",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    onTap: () => _goToLegal()),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Image.network(
                    "https://cdn.pixabay.com/photo/2018/04/24/11/32/book-3346785_1280.png",
                    fit: BoxFit.contain,
                  ),
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
