import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/services/auth.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class CustomAppBar extends StatelessWidget {
  final UserModel currentUser;
  final GroupModel currentGroup;
  CustomAppBar(
      {Key? key, required this.currentUser, required this.currentGroup})
      : super(key: key);

  final AuthService _auth = AuthService();

  void _signOut(BuildContext context) async {
    await _auth.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const AppRoot(),
      ),
      (route) => false,
    );
  }

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
              child: StreamBuilder<GroupModel>(
                  stream: DBStream().getGroupData(currentGroup.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    } else {
                      GroupModel _currentGroup = snapshot.data!;
                      return Text(
                        _currentGroup.name ?? "groupe sans nom",
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 30),
                      );
                    }
                  }),
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
                _signOut(context);
              })
        ],
      ),
    );
  }
}
