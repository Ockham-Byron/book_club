import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/home/noGroupHome/create_group.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'join_group.dart';

class NoGroup extends StatelessWidget {
  const NoGroup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _currentUser = Provider.of<UserModel>(context);
    void _goToJoin() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => JoinGroup(
            userModel: _currentUser,
          ),
        ),
      );
    }

    void _goToCreate() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateGroup(
            currentUser: _currentUser,
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(40, 10, 40, 100),
            child: const Image(
              image: AssetImage("assets/images/logo.png"),
            ),
          ),
          const Text(
            "Bienvenue au club",
            textAlign: TextAlign.center,
            // style: GoogleFonts.oswald(
            //   textStyle: TextStyle(
            //       fontSize: 40, color: Theme.of(context).primaryColor),
            // ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Maintenant, il est temps de rejoindre un club de lecture ou... d'en créer un.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _goToJoin(),
                  child: Text(
                    "Rejoindre un club",
                    style: TextStyle(color: Theme.of(context).shadowColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).canvasColor,
                    fixedSize: const Size(150, 50),
                    side: BorderSide(
                        width: 1, color: Theme.of(context).shadowColor),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50)),
                    onPressed: () => _goToCreate(),
                    child: const Text("Créer un club")),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
