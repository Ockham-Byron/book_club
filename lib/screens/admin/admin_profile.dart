import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/screens/admin/nb_of_read_pages.dart';
import 'package:book_club/screens/edit/edit_user.dart';
import 'package:book_club/sections/book_section/book_section.dart';
import 'package:book_club/services/db_stream.dart';

import 'package:book_club/shared/loading.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';

class ProfileAdmin extends StatefulWidget {
  final UserModel currentUser;

  final GroupModel currentGroup;
  //final BookModel currentBook;
  const ProfileAdmin({
    Key? key,
    required this.currentUser,
    required this.currentGroup,
    //required this.currentBook,
  }) : super(key: key);

  @override
  _ProfileAdminState createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  late int nbOfReadPages = 0;
  List<BookModel> readBooks = [];
  List<int> readBooksPages = [];

  bool withProfilePicture() {
    if (widget.currentUser.pictureUrl == "") {
      return false;
    } else {
      return true;
    }
  }

  String getUserPseudo(UserModel currentUser) {
    String userPseudo;
    if (currentUser.pseudo == null) {
      userPseudo = "personne";
    } else {
      userPseudo = currentUser.pseudo!;
    }
    return "${userPseudo[0].toUpperCase()}${userPseudo.substring(1)}";
  }

  @override
  Widget build(BuildContext context) {
    Widget displayCircularAvatar() {
      if (withProfilePicture()) {
        return CircularProfileAvatar(
          widget.currentUser.pictureUrl!,
          showInitialTextAbovePicture: false,
        );
      } else {
        return CircularProfileAvatar(
          "https://digitalpainting.school/static/img/default_avatar.png",
          foregroundColor: Theme.of(context).focusColor.withOpacity(0.5),
          initialsText: Text(
            widget.currentUser.pseudo![0].toUpperCase(),
            style: const TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          showInitialTextAbovePicture: false,
        );
      }
    }

    int getUserReadBooks(UserModel currentUser) {
      int readBooks;
      if (currentUser.readBooks != null) {
        readBooks = currentUser.readBooks!.length;
      } else {
        readBooks = 0;
      }
      return readBooks;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<UserModel>(
            stream: DBStream().getUserData(widget.currentUser.uid!),
            builder: (context, snapshot) {
              UserModel _currentUser = UserModel();
              if (snapshot.connectionState == ConnectionState.waiting) {
                //print("waiting");
                return const Loading();
              } else {
                if (snapshot.hasError) {
                  // print("y a une erreur : " + snapshot.error.toString());
                  return const Loading();
                } else {
                  if (!snapshot.hasData) {
                    //print("pas de data");
                    return const Loading();
                  } else {
                    _currentUser = snapshot.data!;

                    return Container(
                      padding: const EdgeInsets.only(top: 50),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.jpg'),
                            fit: BoxFit.cover),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 50),
                            height: 1350,
                            decoration: BoxDecoration(
                              color: Colors.amber[50],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                children: [
                                  Text(
                                    getUserPseudo(_currentUser),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 36,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => EditUser(
                                                  currentGroup:
                                                      widget.currentGroup,
                                                  currentUser: _currentUser)));
                                    },
                                    child: Text(
                                      "MODIFIER",
                                      style: TextStyle(color: Colors.red[300]),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: const [
                                            Text(
                                              "LIVRES LUS",
                                              style: kTitleStyle,
                                            ),
                                            Text(
                                              "PAGES LUES",
                                              style: kTitleStyle,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              getUserReadBooks(_currentUser)
                                                  .toString(),
                                              style: kSubtitleStyle,
                                            ),
                                            ReadPages(
                                                currentGroup:
                                                    widget.currentGroup,
                                                currentUser: _currentUser)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  const Text(
                                    "Continuer de lire",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30),
                                    textAlign: TextAlign.start,
                                  ),
                                  BookSection(
                                    currentGroup: widget.currentGroup,
                                    currentUser: _currentUser,
                                    sectionCategory: "continuer",
                                  ),
                                  const Text(
                                    "Favoris",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30),
                                    textAlign: TextAlign.start,
                                  ),
                                  BookSection(
                                    currentGroup: widget.currentGroup,
                                    currentUser: _currentUser,
                                    sectionCategory: "favoris",
                                  ),
                                  const Text(
                                    "Tous les livres lus",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30),
                                    textAlign: TextAlign.start,
                                  ),
                                  BookSection(
                                    currentGroup: widget.currentGroup,
                                    currentUser: _currentUser,
                                    sectionCategory: "lus",
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.2,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.amber[50]),
                              child: ClipRect(
                                child: displayCircularAvatar(),
                              ),
                            ),
                          ),
                          Positioned(
                              left: 30,
                              top: -15,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AppRoot()),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    );
                  }
                }
              }
            }),
      ),
    );
  }
}

const kTitleStyle = TextStyle(
  fontSize: 20,
  color: Colors.grey,
  fontWeight: FontWeight.w700,
);

final kSubtitleStyle = TextStyle(
  fontSize: 26,
  color: Colors.red[300],
  fontWeight: FontWeight.w700,
);
