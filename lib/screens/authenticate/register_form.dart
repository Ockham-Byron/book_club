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
    return FractionallySizedBox(
      heightFactor: 0.88,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        //height: 600,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  if (!val!.isValidEmail) return 'Entrez un courriel valide';
                },
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
                      print("password non valide");
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
                  // enabledBorder: UnderlineInputBorder(
                  //     borderSide:
                  //         BorderSide(color: Theme.of(context).canvasColor)),
                  // focusedBorder: UnderlineInputBorder(
                  //     borderSide:
                  //         BorderSide(color: Theme.of(context).focusColor)),
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
              CustomFormField(
                hintText: "adresse url de votre photo de profil",
                focusNode: fpicture,
                validator: (val) {
                  if (val!.isValidImageUrl || val == "non") {
                    return null;
                  } else {
                    return 'Url non valide.Y a-t-il un .png ou .jpg à la fin ? Si vous ne souhaitez pas ajouter de photo de profil, écrivez "non"';
                  }
                },
                textEditingController: _pictureInput,
                iconData: Icons.camera,
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
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  // InputDecoration fieldDecoration(
  //     BuildContext context, IconData icon, String labelText) {
  //   return InputDecoration(
  //       enabledBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Theme.of(context).canvasColor)),
  //       focusedBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Theme.of(context).focusColor)),
  //       errorBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(color: Theme.of(context).shadowColor),
  //       ),
  //       prefixIcon: Icon(icon, color: Theme.of(context).focusColor),
  //       labelText: labelText,
  //       labelStyle: TextStyle(color: Theme.of(context).focusColor),
  //       errorStyle: TextStyle(color: Theme.of(context).shadowColor));
  // }
}
