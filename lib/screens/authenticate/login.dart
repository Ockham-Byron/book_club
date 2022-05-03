import 'package:book_club/screens/authenticate/login_form.dart';
import 'package:book_club/screens/authenticate/register.dart';

import 'package:book_club/shared/constraints.dart';
import 'package:book_club/shared/containers/background_container.dart';

import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

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
      body: BackgroundContainer(
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            const LoginForm(),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 80,
              height: 120,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"))),
            ),
          ],
        ),
      ),
    );
  }
}
