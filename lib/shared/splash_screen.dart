import 'package:book_club/services/auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitChasingDots(
            color: Colors.brown,
            size: 50.0,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Les pages tournent, tournent, dans le vide...",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).shadowColor),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: const Text("Fermer le livre"),
          ),
        ],
      ),
    );
  }
}
