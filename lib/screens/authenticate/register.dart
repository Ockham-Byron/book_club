import 'package:book_club/screens/authenticate/register_form.dart';
import 'package:book_club/shared/constraints.dart';
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
    );
  }
}
