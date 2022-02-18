import 'package:book_club/services/auth.dart';
import 'package:book_club/shared/loading.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 300,
          child: Column(
            children: [
              const Loading(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Les pages tournent, tournent, dans le vide...",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                },
                child: const Text("Fermer le livre"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
