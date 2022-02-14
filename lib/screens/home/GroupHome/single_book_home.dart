import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/home/GroupHome/next_book_info.dart';
import 'package:book_club/screens/home/GroupHome/single_book_card.dart';
import 'package:book_club/shared/appBars/custom_app_bar.dart';
import 'package:book_club/shared/app_drawer.dart';

import 'package:book_club/shared/background_container.dart';

import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Column(
          children: [
            CustomAppBar(
              currentUser: widget.currentUser,
              currentGroup: widget.currentGroup,
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
                    SingleBookCard(
                        currentUser: widget.currentUser,
                        currentGroup: widget.currentGroup),
                    NextBookInfo(
                        currentGroup: widget.currentGroup,
                        currentUser: widget.currentUser)
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
