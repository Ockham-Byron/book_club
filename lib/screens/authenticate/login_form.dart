import 'package:book_club/root.dart';
import 'package:book_club/screens/authenticate/register_form.dart';
import 'package:book_club/screens/authenticate/reset_password.dart';
import 'package:book_club/services/auth.dart';

import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:book_club/shared/custom_form_field.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //key for the form's validation
  final _formKey = GlobalKey<FormState>();

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

  //Alert popup mail doesn't exist
  Future<void> _showDialogNoMail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Aucun compte relié à cet email"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    "Si vous n'avez pas de compte et voulez rejoindre le monde merveilleux des groupes de lecture, créez un compte."),
                const Text(
                    "Si vous avez déjà un compte avec un autre mail et que la mémoire vous revient, retournez à l'écran de connection"),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext ctx) {
                              return const RegisterForm();
                            });
                      },
                      child: Text(
                        "Créer un compte".toUpperCase(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Se connecter".toUpperCase(),
                          style:
                              TextStyle(color: Theme.of(context).focusColor)),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('X',
                  style: TextStyle(color: Theme.of(context).focusColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//Alert popup wrong password
  Future<void> _showDialogWrongPassword() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Mauvais mot de passe"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text("Vous pouvez modifier votre mot de passe"
                    " "
                    "Si la mémoire vous revient, retournez à l'écran de connection"),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ResetPassword()));
                      },
                      child: Text(
                        "Modifier le mot de passe".toUpperCase(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Se connecter".toUpperCase(),
                          style:
                              TextStyle(color: Theme.of(context).focusColor)),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('X',
                  style: TextStyle(color: Theme.of(context).focusColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ShadowContainer(
        child: Form(
          key: _formKey,
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
              //Formfield for email
              CustomFormField(
                hintText: "courriel",
                focusNode: fmail,
                textEditingController: _emailInput,
                iconData: Icons.alternate_email,
                validator: (val) {
                  if (!val!.isValidEmail) {
                    return 'Entrez un courriel valide';
                  } else {
                    return null;
                  }
                },
              ),

              TextFormField(
                focusNode: fpassword,
                obscureText: _isHidden,
                controller: _passwordInput,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Merci d'indiquer votre mot de passe";
                  } else {
                    return null;
                  }
                },
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String message;
                    message = await AuthService()
                        .logInUser(_emailInput.text, _passwordInput.text);
                    if (message ==
                        "There is no user record corresponding to this identifier. The user may have been deleted.") {
                      _showDialogNoMail();
                    } else if (message ==
                        "The password is invalid or the user does not have a password.") {
                      _showDialogWrongPassword();
                    } else if (message == "success") {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AppRoot(),
                        ),
                      );
                    }
                  }
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ResetPassword())));
                  },
                  child: Text(
                    "Oubli du mot de passe ?",
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
