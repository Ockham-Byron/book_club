import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class CustomAppBar extends StatelessWidget {
  final UserModel currentUser;
  final GroupModel currentGroup;
  CustomAppBar(
      {Key? key, required this.currentUser, required this.currentGroup})
      : super(key: key);

  final AuthService _auth = AuthService();

  String _displayGroupName() {
    if (currentGroup.name != null) {
      return currentGroup.name!;
    } else {
      return "Groupe sans nom";
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget displayCircularAvatar() {
      if (currentUser.pictureUrl != null) {
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
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          showInitialTextAbovePicture: true,
        );
      }
    }

    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 50,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Builder(
                builder: (context) => GestureDetector(
                  child: displayCircularAvatar(),
                  onTap: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              width: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey.shade200.withOpacity(0.5)),
              child: Text(
                _displayGroupName(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                await _auth.signOut();
              })
        ],
      ),
    );
  }
}
