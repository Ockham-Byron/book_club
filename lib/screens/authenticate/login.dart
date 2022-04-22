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
            Container(
              width: 100,
              height: 150,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"))),
            ),
            const SizedBox(height: 50),
            const LoginForm(),
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
              color: Theme.of(context).canvasColor,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Register(),
                    ));
                    // showModalBottomSheet(
                    //     constraints: BoxConstraints(
                    //         maxWidth: mobileMaxWidth,
                    //         maxHeight: mobileContainerMaxHeight),
                    //     shape: const RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.only(
                    //             topLeft: Radius.circular(30),
                    //             topRight: Radius.circular(30))),
                    //     isScrollControlled: true,
                    //     context: context,
                    //     builder: (BuildContext ctx) {
                    //       return DraggableScrollableSheet(
                    //           initialChildSize: 1,
                    //           minChildSize: 0.25,
                    //           maxChildSize: 1,
                    //           expand: true,
                    //           builder: (context, scrollController) =>
                    //               const RegisterForm());
                    //     });
                  },
                  child: Text(
                    "Pas encore de compte ?".toUpperCase(),
                    style: TextStyle(color: Theme.of(context).focusColor),
                  )),
            )),
      ),
    );
  }
}
