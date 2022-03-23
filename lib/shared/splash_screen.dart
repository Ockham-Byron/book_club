import 'package:book_club/services/auth.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Book_06490_20040730160049_L.jpg/256px-Book_06490_20040730160049_L.jpg"),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Les pages tournent, tournent, dans le vide...",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
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
            const SizedBox(
              height: 200,
            ),
            const Text(
              'Crédit photo : I, Nevit Dilmen, CC BY-SA 3.0, via Wikimedia Commons" ',
              style: TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
