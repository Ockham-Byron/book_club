import 'package:book_club/root.dart';
import 'package:book_club/services/auth.dart';

import 'package:book_club/shared/shadow_container.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //focus
  FocusNode? fmail;
  FocusNode? fpassword;

  //Text input controllers
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();

  //hide or show password
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  //function to logIn the user
  void _logInUser(String email, String password) async {
    try {
      if (await AuthService().logInUser(email, password)) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AppRoot(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Mauvais email ou mauvais mot de passe, du coup ça marche pas"),
          ),
        );
      }
    } catch (e) {
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: ShadowContainer(
          child: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Salut à toi, avide de lectures !",
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              autofocus: true,
              focusNode: fmail,
              onTap: () {
                setState(() {
                  FocusScope.of(context).requestFocus(fmail);
                });
              },
              textInputAction: TextInputAction.next,
              controller: _emailInput,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).canvasColor)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).focusColor)),
                labelText: "courriel",
                labelStyle: TextStyle(color: Theme.of(context).focusColor),
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: Theme.of(context).focusColor,
                ),
              ),
              style: Theme.of(context).textTheme.bodyText2,
              onFieldSubmitted: (term) {
                fmail!.unfocus();
                FocusScope.of(context).requestFocus(fpassword);
              },
            ),
            TextFormField(
              focusNode: fpassword,
              obscureText: _isHidden,
              controller: _passwordInput,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).canvasColor)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).focusColor)),
                prefixIcon: Icon(Icons.lock_outline,
                    color: Theme.of(context).focusColor),
                labelText: "mot de passe",
                labelStyle: TextStyle(color: Theme.of(context).focusColor),
                suffixIcon: IconButton(
                  onPressed: _togglePasswordView,
                  icon: Icon(
                    _isHidden ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).focusColor,
                minimumSize: const Size(250, 50),
              ),
              onPressed: () {
                _logInUser(_emailInput.text, _passwordInput.text);
              },
              child: const Text(
                "SE CONNECTER",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
                onPressed: () {
                  // showDialog(
                  //     context: context,
                  //     builder: (context) => _buildPopupResetPassword(context));
                },
                child: Text(
                  "Oubli du mot de passe ?",
                  style: TextStyle(color: Theme.of(context).focusColor),
                ))
          ],
        ),
      )),
    );
  }
}
