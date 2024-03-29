import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/constraints.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/display_services.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/user_model.dart';
import '../../shared/appBars/custom_app_bar.dart';
import '../../shared/app_drawer.dart';
import 'borrower_change.dart';

class ChangeBorrower extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final BookModel currentBook;
  const ChangeBorrower(
      {Key? key,
      required this.currentGroup,
      required this.currentUser,
      required this.currentBook})
      : super(key: key);

  @override
  State<ChangeBorrower> createState() => _ChangeBorrowerState();
}

class _ChangeBorrowerState extends State<ChangeBorrower> {
  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(
        ClipboardData(text: getGroupId(widget.currentGroup)));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Copié dans le presse papier")));
  }

  Widget _displayWaitingList(List<UserModel> members) {
    if (widget.currentBook.waitingList!.isEmpty) {
      return SizedBox(
        width: 320,
        child: Column(
          children: [
            Text(
              "Membres en liste d'attente",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 100,
              child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/7/7f/Dicoo_bienvenue.png"),
            ),
            Text(
              "Personne en liste d'attente",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: members.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Text(
                "Membres en liste d'attente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            } else {
              return BorrowerChange(
                user: members[index - 1],
                currentUser: widget.currentUser,
                currentGroup: widget.currentGroup,
                currentBook: widget.currentBook,
              );
            }
          });
    }
  }

  Widget _displayMembersList(List<UserModel> members) {
    if (members.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 100,
            child: Image.network(
                "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Il n'y a pas d'autre membre à qui prêter ce livre",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Invitez des passionnés de lecture à vous rejoindre",
            textAlign: TextAlign.center,
          ),
          Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              children: [
                const Text(
                  "Code du groupe à partager aux nouveaux membres",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getGroupId(widget.currentGroup),
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        child: Icon(
                          Icons.copy,
                          color: Colors.white,
                        ),
                        onTap: _copyToClipboard,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
          )
        ],
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView.builder(
            primary: false,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: members.length + 1,
            itemBuilder: (BuildContext context, int index) {
              print("taille de la liste");
              print(members.length);
              if (index == 0) {
                return Container();
              } else {
                return BorrowerChange(
                  user: members[index - 1],
                  currentUser: widget.currentUser,
                  currentGroup: widget.currentGroup,
                  currentBook: widget.currentBook,
                );
              }
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return computerLayout(globalWidget());
        } else {
          return globalWidget();
        }
      },
    );
  }

  StreamBuilder<BookModel> globalWidget() {
    return StreamBuilder<BookModel>(
        stream: DBStream().getBookData(
            groupId: widget.currentGroup.id!, bookId: widget.currentBook.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            BookModel _currentBook = snapshot.data!;

            return Scaffold(
              body: BackgroundContainer(
                child: ListView(
                  primary: true,
                  children: [
                    CustomAppBar(
                        currentUser: widget.currentUser,
                        currentGroup: widget.currentGroup),
                    Container(
                      height: 900,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: ListView(
                        primary: false,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            height: 180,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 150,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            displayBookCoverUrl(_currentBook)),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentBook.title ?? "Pas de titre",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context).focusColor),
                                    ),
                                    Text(
                                      _currentBook.author ?? "Pas d'auteur",
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      _currentBook.length.toString() + " pages",
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Livre actuellement prêté à "),
                              StreamBuilder<UserModel>(
                                  stream: DBStream()
                                      .getUserData(_currentBook.lenderId!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Loading();
                                    } else if (!snapshot.hasData) {
                                      return Text("personne");
                                    } else {
                                      UserModel _user = snapshot.data!;
                                      return Text(
                                        "${_user.pseudo![0].toUpperCase()}${_user.pseudo!.substring(1)}",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).focusColor),
                                      );
                                    }
                                  })
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Text(
                              "Choisissez la nouvelle personne à qui prêter ce livre",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          StreamBuilder<List<UserModel>>(
                              stream: DBStream().getAllUsers(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Loading();
                                } else {
                                  List<UserModel> allUsers = snapshot.data!;
                                  List<UserModel> members = [];
                                  List<UserModel> waitingList = [];
                                  for (var user in allUsers) {
                                    if (widget.currentGroup.members!
                                        .contains(user.uid)) {
                                      members.add(user);
                                    }
                                  }

                                  for (var user in allUsers) {
                                    if (_currentBook.lenderId == user.uid ||
                                        _currentBook.ownerId == user.uid ||
                                        _currentBook.waitingList!
                                            .contains(user.uid) ||
                                        user.readBooks!
                                            .contains(_currentBook.id)) {
                                      members.remove(user);
                                    }
                                  }

                                  for (var user in allUsers) {
                                    if (_currentBook.waitingList!
                                        .contains(user.uid)) {
                                      waitingList.add(user);
                                    }
                                  }
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Theme.of(context)
                                                    .shadowColor
                                                    .withOpacity(0.5)),
                                            child: _displayWaitingList(
                                                waitingList)),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Autres membres",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).shadowColor),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      _displayMembersList(members)
                                    ],
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              drawer: AppDrawer(
                currentGroup: widget.currentGroup,
                currentUser: widget.currentUser,
              ),
            );
          }
        });
  }
}
