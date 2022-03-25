import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/home/GroupHome/next_book_info.dart';
import 'package:book_club/screens/home/GroupHome/single_book_card.dart';

import 'package:book_club/shared/appBars/custom_app_bar.dart';
import 'package:book_club/shared/app_drawer.dart';

import 'package:book_club/shared/containers/background_container.dart';

import 'package:flutter/material.dart';

import '../../../shared/constraints.dart';
import '../../create/add_book.dart';

class SingleBookHome extends StatefulWidget {
  final UserModel currentUser;
  final GroupModel currentGroup;
  const SingleBookHome(
      {Key? key, required this.currentUser, required this.currentGroup})
      : super(key: key);

  @override
  _SingleBookHomeState createState() => _SingleBookHomeState();
}

class _SingleBookHomeState extends State<SingleBookHome> {
  void _goToAddBook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBook(
          currentGroup: widget.currentGroup,
          currentUser: widget.currentUser,
        ),
      ),
    );
  }

  _displayHomeWidget() {
    if (widget.currentGroup.currentBookId != null) {
      return Column(
        children: [
          SingleBookCard(
              currentUser: widget.currentUser,
              currentGroup: widget.currentGroup),
          NextBookInfo(
              currentGroup: widget.currentGroup,
              currentUser: widget.currentUser)
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(
                right: 50,
              ),
              child: Image.network(
                  "https://cdn.pixabay.com/photo/2017/05/27/20/51/book-2349419_1280.png"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Il n'y a pas encore de livre dans ce groupe ;(",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => _goToAddBook(),
              child: const Text("Ajouter le premier livre"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return Center(
            child: SizedBox(
              width: mobileMaxWidth,
              height: mobileContainerMaxHeight,
              child: globalWidget(context),
            ),
          );
        } else {
          return globalWidget(context);
        }
      },
    );
  }

  Scaffold globalWidget(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: ListView(
          children: [
            SizedBox(
              height: 160,
              child: CustomAppBar(
                currentUser: widget.currentUser,
                currentGroup: widget.currentGroup,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 50,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bonjour",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${widget.currentUser.pseudo![0].toUpperCase()}${widget.currentUser.pseudo!.substring(1)}",
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 15,
                              bottom: 30,
                            ),
                            width: 100,
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _displayHomeWidget()
                  ],
                ),
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
}
