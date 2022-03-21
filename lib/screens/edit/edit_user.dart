import 'dart:ui';

import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/screens/admin/admin_profile.dart';
import 'package:book_club/services/auth.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../shared/custom_form_field.dart';

class EditUser extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;

  const EditUser({
    Key? key,
    required this.currentGroup,
    required this.currentUser,
  }) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  //keys for the forms validation
  final _pictureFormKey = GlobalKey<FormState>();
  final _pseudoFormKey = GlobalKey<FormState>();
  final _mailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  //focus nodes
  FocusNode? fPicture;
  FocusNode? fMail;
  FocusNode? fPseudo;
  FocusNode? fPassword;

  //initial values
  String? initialPseudo;
  String? initialMail;
  String? initialProfilePicture;

  @override
  void initState() {
    initialPseudo = widget.currentUser.pseudo;
    initialMail = widget.currentUser.email;
    initialProfilePicture = widget.currentUser.pictureUrl;
    _userPseudoInput.text = initialPseudo!;
    _userMailInput.text = initialMail!;
    _userProfileInput.text = initialProfilePicture!;

    super.initState();
  }

  //input controllers
  final TextEditingController _userPseudoInput = TextEditingController();
  final TextEditingController _userMailInput = TextEditingController();
  final TextEditingController _userProfileInput = TextEditingController();

  void _editUserPseudo(
      String pseudo, String userId, BuildContext context) async {
    try {
      String _returnString = await DBFuture().editUserPseudo(userId, pseudo);
      if (_returnString == "success") {
        Fluttertoast.showToast(
            msg:
                "Votre pseudo est modifié ! Changer d'identité est une des vertus de la littérature...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileAdmin(
                currentGroup: widget.currentGroup,
                currentUser: widget.currentUser)));
      } else {
        Fluttertoast.showToast(
            msg:
                "Ne me demandez pas pourquoi, mais ça n'a pas fonctionné. Il faut parfois accepter l'incertitude...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      //print("y a un problème");
    }
  }

  void _deleteUser(String userId, String groupId, BuildContext context) async {
    try {
      String _returnString = await AuthService().deleteUser();

      if (_returnString == "success") {
        DBFuture().deleteUserFromDb(
          widget.currentUser.uid!,
        );

        DBFuture().deleteUserFromGroup(
          widget.currentUser.uid!,
          widget.currentGroup.id!,
        );

        Fluttertoast.showToast(
            msg: "Votre compte est supprimé, bonjour tristesse...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
        _signOut(context);
      } else if (_returnString == "error") {
        Fluttertoast.showToast(
            msg:
                "Opération sensible ! Vous devez vous connecter de nouveau pour la mener en toute sécurité.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      //print(e);
    }
  }

  void _editUserPicture(String pictureUrl, String userId) async {
    try {
      String _returnString =
          await DBFuture().editUserPicture(userId, pictureUrl);

      if (_returnString == "success") {
        Fluttertoast.showToast(
            msg: "C'est bon vous avez changé de tête !",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).focusColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg:
                "Avez_vous l'absolue certitude d'avoir copié collé un format image ?",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).focusColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      //print(e);
    }
  }

  void _editUserMail({required String userId, required String mail}) async {
    try {
      String _returnString = await AuthService().resetEmail(mail);
      if (_returnString == "success") {
        DBFuture().editUserMail(userId, mail);
        Fluttertoast.showToast(
            msg:
                "Votre mail est modifié ! Changer d'adresse sans bouger de son canapé, quel confort...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).focusColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (_returnString == "exception") {
        Fluttertoast.showToast(
            msg:
                "Opération sensible ! Vous devez vous connecter de nouveau pour la mener en toute sécurité.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).focusColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg:
                "Opération sensible ! Vous devez vous connecter de nouveau pour la mener en toute sécurité.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).focusColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      //print(e);
    }
  }

  void _resetPassword(String email) async {
    try {
      await AuthService().sendPasswordResetEmail(email);
    } catch (e) {
      //print(e);
    }
  }

  void _signOut(BuildContext context) async {
    String _returnedString = await AuthService().signOut();
    if (_returnedString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AppRoot(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            flexibleSpace: Column(
              children: [
                TabBar(
                  unselectedLabelColor: Theme.of(context).focusColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).focusColor),
                  tabs: const [
                    KTab(
                      iconData: Icons.person,
                    ),
                    KTab(iconData: Icons.camera),
                    KTab(iconData: Icons.mail_outline),
                    KTab(iconData: Icons.lock),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //Modifier pseudo
              BackgroundContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 280,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ShadowContainer(
                        child: Form(
                          key: _pseudoFormKey,
                          child: Column(
                            children: [
                              CustomFormField(
                                focusNode: fPseudo,
                                textEditingController: _userPseudoInput,
                                iconData: Icons.person,
                                hintText: "Pseudo",
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
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    primary: Theme.of(context).focusColor),
                                onPressed: () {
                                  if (_pseudoFormKey.currentState!.validate()) {
                                    _editUserPseudo(_userPseudoInput.text,
                                        widget.currentUser.uid!, context);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Text(
                                    "Modifier".toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Annuler".toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ShadowContainer(
                        child: TextButton(
                          onPressed: () => _deleteUser(widget.currentUser.uid!,
                              widget.currentGroup.id!, context),
                          child: Text(
                            "Supprimer mon compte".toUpperCase(),
                            style:
                                TextStyle(color: Theme.of(context).focusColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              //Modifier Picture
              BackgroundContainer(
                child: Center(
                  child: Container(
                    height: 285,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ShadowContainer(
                      child: Form(
                        key: _pictureFormKey,
                        child: Column(
                          children: [
                            CustomFormField(
                              focusNode: fPicture,
                              textEditingController: _userProfileInput,
                              iconData: Icons.camera,
                              hintText: "Url de votre photo de profil",
                              validator: (val) {
                                if (val!.isValidImageUrl || val == "") {
                                  return null;
                                } else {
                                  return 'Url non valide.Y a-t-il un .png ou .jpg à la fin ? Si vous ne souhaitez pas ajouter de photo de profil, laissez vide';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  primary: Theme.of(context).focusColor),
                              onPressed: () {
                                if (_pictureFormKey.currentState!.validate()) {
                                  _editUserPicture(_userProfileInput.text,
                                      widget.currentUser.uid!);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "Modifier".toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Annuler".toUpperCase(),
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //Modifier Mail
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Center(
                    child: Container(
                      height: 325,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ShadowContainer(
                        child: Form(
                          key: _mailFormKey,
                          child: Column(
                            children: [
                              CustomFormField(
                                focusNode: fMail,
                                textEditingController: _userMailInput,
                                iconData: Icons.alternate_email,
                                hintText: "Courriel",
                                validator: (val) {
                                  if (!val!.isValidEmail) {
                                    return 'Entrez un courriel valide';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    primary: Theme.of(context).focusColor),
                                onPressed: () {
                                  if (_mailFormKey.currentState!.validate()) {
                                    _editUserMail(
                                      userId: widget.currentUser.uid!,
                                      mail: _userMailInput.text,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Text(
                                    "Modifier".toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                onPressed: () => _signOut(context),
                                child: Text(
                                  "Se déconnecter".toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Annuler".toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Modifier Mot de passe
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Center(
                    child: Container(
                      height: 320,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ShadowContainer(
                        child: Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              CustomFormField(
                                textEditingController: _userMailInput,
                                iconData: Icons.alternate_email,
                                hintText: "Votre courriel",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                  "Vous souhaitez changer de mot de passe ? Vérifiez votre courriel ci-dessus, nous allons y envoyer un lien pour modifier votre mot de passe."),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    primary: Theme.of(context).focusColor),
                                onPressed: () {
                                  _resetPassword(_userMailInput.text);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Text(
                                    "Envoyer".toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Annuler".toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KTab extends StatelessWidget {
  final IconData iconData;
  const KTab({Key? key, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Theme.of(context).focusColor, width: 3)),
        child: Align(alignment: Alignment.center, child: Icon(iconData)),
      ),
    );
  }
}
