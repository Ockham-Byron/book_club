import 'package:book_club/services/auth.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  //focus
  FocusNode? fpseudo;
  FocusNode? fmail;
  FocusNode? fpassword;
  FocusNode? fpasswordbis;
  FocusNode? fpicture;

  //input controllers
  final TextEditingController _pseudoInput = TextEditingController();
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final TextEditingController _passwordBisInput = TextEditingController();
  final TextEditingController _pictureInput = TextEditingController();

  //show or hide password
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  //key for the form's validation
  final _formKey = GlobalKey<FormState>();

  //function to register the user
  void _signUpUser(
      String email, String password, String pseudo, String pictureUrl) async {
    try {
      String _message =
          await AuthService().registerUser(email, password, pseudo, pictureUrl);
      if (_message == "success") {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_message)));
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      height: 500,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Tout commence par un incipit",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) =>
                  value!.isEmpty ? "Merci d'indiquer un pseudo" : null,
              focusNode: fpseudo,
              controller: _pseudoInput,
              decoration: fieldDecoration(context, Icons.person, "pseudo"),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextFormField(
              validator: (value) =>
                  value!.isEmpty ? "Merci d'indiquer un email" : null,
              focusNode: fmail,
              controller: _emailInput,
              decoration:
                  fieldDecoration(context, Icons.alternate_email, "courriel"),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextFormField(
              focusNode: fpassword,
              controller: _passwordInput,
              obscureText: _isHidden,
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
            TextFormField(
              focusNode: fpasswordbis,
              controller: _passwordBisInput,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).canvasColor)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).focusColor)),
                prefixIcon: Icon(Icons.lock_outline,
                    color: Theme.of(context).focusColor),
                labelText: "mot de passe bis repetita",
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
            TextFormField(
              focusNode: fpicture,
              controller: _pictureInput,
              decoration: fieldDecoration(context, Icons.camera,
                  "adresse url de votre photo de profil"),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).focusColor,
                minimumSize: const Size(250, 50),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_passwordInput.text == _passwordBisInput.text) {
                    _signUpUser(_emailInput.text, _passwordInput.text,
                        _pseudoInput.text, _pictureInput.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("mots de passe différents"),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                "S'INSCRIRE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration fieldDecoration(
      BuildContext context, IconData icon, String labelText) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).canvasColor)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).focusColor)),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).shadowColor),
        ),
        prefixIcon: Icon(icon, color: Theme.of(context).focusColor),
        labelText: labelText,
        labelStyle: TextStyle(color: Theme.of(context).focusColor),
        errorStyle: TextStyle(color: Theme.of(context).shadowColor));
  }
}
