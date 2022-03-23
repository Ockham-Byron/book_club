import 'package:book_club/root.dart';
import 'package:book_club/screens/legal/terms_conditions.dart';
import 'package:flutter/material.dart';

class Legal extends StatelessWidget {
  const Legal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kStyle = TextStyle(color: Theme.of(context).focusColor);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AppRoot(),
                    ),
                    (route) => false),
                child: Text(
                  "retour".toUpperCase(),
                  style: kStyle,
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TermsAndConditions(),
                  ));
                },
                child: Text(
                  "Terms and Conditions",
                  style: kStyle,
                ))
          ],
        ),
      ),
    );
  }
}
