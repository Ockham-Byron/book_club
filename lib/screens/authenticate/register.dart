import 'package:book_club/screens/authenticate/login.dart';
import 'package:book_club/screens/authenticate/login_form.dart';
import 'package:book_club/screens/authenticate/register_form.dart';
import 'package:book_club/shared/constraints.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';

import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return Center(
            child: SizedBox(
              width: mobileMaxWidth,
              height: mobileContainerMaxHeight,
              child: globalWidget(context),
            ),
          );
        } else {
          return globalWidget(context);
        }
      },
    );
  }

  Scaffold globalWidget(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          primary: true,
          children: [
            const SizedBox(
              height: 50,
            ),
            const RegisterForm(),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Container(
              height: 50,
              color: Theme.of(context).focusColor,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LogIn(),
                    ));
                  },
                  child: Text(
                    "Déjà inscrit ?".toUpperCase(),
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  )),
            )),
      ),
    );
  }
}
