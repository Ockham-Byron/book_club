import 'package:book_club/root.dart';
import 'package:book_club/screens/authenticate/reset_password.dart';
import 'package:book_club/services/auth.dart';
import 'package:book_club/shared/custom_form_field.dart';

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

  //Alert popup show url explanation
  Future<void> _showUrlExplanation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Text(
            "Comment récupérer l'url de votre photo de profil ?",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    'Trouvez une photo de vous (ou qui vous représente) sur internet.'),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    "Si vous êtes sur un mobile, appuyez longuement sur l'image. Sur un ordinateur, faites un clic droit."),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    'Dans la liste d\'options, choisissez "copier le lien".'),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    'Collez ce lien dans le champ "url de votre photo de profil".'),
                const SizedBox(
                  height: 10,
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

  //Alert popup existing mail
  Future<void> _showDialogExistingMail() async {
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

  //Alert popup unknown problem
  Future<void> _showDialogProblem() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(";_("),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Un problème inconnu est survenu, veuillez réessayer plus tard'),
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
      height: 550,
      //widthFactor: 0.5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              //Form field for the name
              CustomFormField(
                hintText: "pseudo",
                focusNode: fpseudo,
                textEditingController: _pseudoInput,
                iconData: Icons.person,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Merci d'indiquer un pseudo";
                  } else if (val.length < 3) {
                    return "Merci de choisir un pseudo de plus de trois caractères";
                  } else {
                    return null;
                  }
                },
              ),
              //Form Field for the mail
              CustomFormField(
                hintText: "courriel",
                iconData: Icons.alternate_email,
                focusNode: fmail,
                textEditingController: _emailInput,
                validator: (val) {
                  if (!val!.isValidEmail) {
                    return 'Entrez un courriel valide';
                  } else {
                    return null;
                  }
                },
              ),
              Text(
                "Votre mot de passe doit comporter au moins 8 caractères, dont une majuscule, une minuscule, un chiffre et un caractère spécial",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15),
              ),

              TextFormField(
                focusNode: fpassword,
                controller: _passwordInput,
                obscureText: _isHidden,
                validator: (val) {
                  if (val!.length > 7) {
                    if (val.isValidPassword) {
                      return null;
                    } else {
                      return "Votre mot de passe doit comporter au moins 8 caractères, dont une majuscule, une minuscule, un chiffre et un caractère spécial";
                    }
                  } else {
                    return "Votre mot de passe doit comporter au moins 8 caractères, dont une majuscule, une minuscule, un chiffre et un caractère spécial";
                  }
                },
                decoration: InputDecoration(
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
                  errorMaxLines: 3,
                ),
                // style: Theme.of(context).textTheme.bodyText2,
              ),
              TextFormField(
                focusNode: fpasswordbis,
                controller: _passwordBisInput,
                validator: (val) {
                  if (_passwordInput.text != val) {
                    return "Les deux mots de passe sont différents";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
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
              ),
              //Form Field for the picture
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 280,
                    child: CustomFormField(
                      hintText: "url de votre photo de profil (facultatif)",
                      focusNode: fpicture,
                      validator: (val) {
                        if (val!.isValidImageUrl || val == "") {
                          return null;
                        } else {
                          return 'Url non valide.Y a-t-il un .png ou .jpg à la fin ? Si vous ne souhaitez pas ajouter de photo de profil, laissez vide';
                        }
                      },
                      textEditingController: _pictureInput,
                      iconData: Icons.camera,
                    ),
                  ),
                  IconButton(
                      onPressed: () => _showUrlExplanation(),
                      icon: Icon(
                        Icons.info,
                        color: Theme.of(context).focusColor,
                      )),
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).focusColor,
                  minimumSize: const Size(250, 50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String message;
                    message = await AuthService().registerUser(
                        _emailInput.text,
                        _passwordInput.text,
                        _pseudoInput.text,
                        _pictureInput.text);

                    if (message == "Il existe déjà un compte avec ce mail.") {
                      _showDialogExistingMail();
                    } else if (message == "success") {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const AppRoot()),
                          (route) => false);
                    } else {
                      _showDialogProblem();
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
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
