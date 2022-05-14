import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/screens/admin/nb_of_read_pages.dart';
import 'package:book_club/screens/edit/edit_user.dart';
import 'package:book_club/sections/book_section/book_section.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/constraints.dart';

import 'package:book_club/shared/loading.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import 'package:flutter/material.dart';

import '../history/book_history.dart';

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

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return Center(
              child: SizedBox(
                  width: mobileMaxWidth,
                  height: mobileContainerMaxHeight,
                  child:
                      globalWidget(getUserReadBooks, displayCircularAvatar)));
        } else {
          return globalWidget(getUserReadBooks, displayCircularAvatar);
        }
      },
    );
  }

  Scaffold globalWidget(int Function(UserModel currentUser) getUserReadBooks,
      Widget Function() displayCircularAvatar) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<UserModel>(
            stream: DBStream().getUserData(widget.currentUser.uid!),
            builder: (context, snapshot) {
              UserModel _currentUser = UserModel();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              } else {
                if (snapshot.hasError) {
                  return const Loading();
                } else {
                  if (!snapshot.hasData) {
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
                            height: 1707,
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
                                  SizedBox(
                                    height: 0,
                                  ),
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
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).canvasColor,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
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
                                    height: 10,
                                  ),
                                  KBookSection(
                                      widget: widget,
                                      title: "à continuer",
                                      barWidth: 115),
                                  KBookSection(
                                      widget: widget,
                                      title: "favoris",
                                      barWidth: 65),
                                  KBookSection(
                                      widget: widget,
                                      title: "lus",
                                      barWidth: 25)
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

class KBookSection extends StatelessWidget {
  const KBookSection(
      {Key? key,
      required this.widget,
      required this.title,
      required this.barWidth})
      : super(key: key);

  final ProfileAdmin widget;
  final String? title;
  final double? barWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Livres",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: ColorBar(barWidth: barWidth),
                    ),
                    Text(
                      title!,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            transform: Matrix4.translationValues(0, -28, 0),
            child: BookSection(
                currentGroup: widget.currentGroup,
                currentUser: widget.currentUser,
                sectionCategory: title!),
          ),
          Container(
            transform: Matrix4.translationValues(0, -28, 0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[400]),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)))),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookHistory(
                    currentGroup: widget.currentGroup,
                    currentUser: widget.currentUser,
                    title: title,
                  ),
                ));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Voir tous les livres $title'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.read_more,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorBar extends StatelessWidget {
  final double? barWidth;
  const ColorBar({Key? key, required this.barWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 15,
        bottom: 30,
      ),
      width: barWidth,
      height: 15,
      color: Theme.of(context).focusColor.withOpacity(0.7),
    );
  }
}
