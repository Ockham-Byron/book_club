import 'package:book_club/services/auth.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("les pages tournent, tournent, dans le vide..."),
            ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                },
                child: const Text("Fermer le livre"))
          ],
        ),
      ),
    );
  }
}
