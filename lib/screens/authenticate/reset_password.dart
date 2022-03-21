import 'package:book_club/services/auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({Key? key}) : super(key: key);

  //key for the form's validation
  final _formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return "Entrez une adresse mail valide";
    } else {
      return null;
    }
  }

  //Alert popup existing mail
  Future<void> _showDialogExistingMail(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cet email correspond déjà à un compte"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    'Si vous avez oublié votre mot de passe, vous pouvez le modifier. '),
                const Text(
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
                            builder: ((context) => ResetPassword())));
                      },
                      child: Text(
                        "Modifier mot de passe".toUpperCase(),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
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

  final TextEditingController _emailInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
              child: const Image(
                image: AssetImage("assets/images/reset_password.png"),
              ),
            ),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Oubli du mot de passe ? Ca arrive aux meilleurs...",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Indiquez votre email et nous vous enverrons un lien pour changer votre mot de passe",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                        controller: _emailInput,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).focusColor,
                                  width: 2),
                            ),
                            //filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Votre email",
                            fillColor: Colors.white70),
                        validator: (val) => validateEmail(val)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String message;
                        try {
                          message = await AuthService()
                              .sendPasswordResetEmail(_emailInput.text);
                          if (message == "success") {
                            //show dialog aller consulter son email
                          } else if (message ==
                              "Aucun compte correspondant à ce mail.") {
                            _showDialogExistingMail(context);
                          }
                          //dire d'aller voir son email
                        } catch (e) {
                          //
                        }
                      }
                    },
                    child: const Text('Ok'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
