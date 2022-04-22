import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_group.dart';
import 'package:book_club/screens/home/GroupHome/next_book_info.dart';
import 'package:book_club/screens/home/GroupHome/single_book_card.dart';
import 'package:book_club/sections/book_section/book_section.dart';

import 'package:book_club/shared/appBars/custom_app_bar.dart';
import 'package:book_club/shared/app_drawer.dart';

import 'package:book_club/shared/containers/background_container.dart';

import 'package:flutter/material.dart';

import '../../../shared/constraints.dart';
import '../../create/add_book.dart';

class SeveralBooksHome extends StatefulWidget {
  final UserModel currentUser;
  final GroupModel currentGroup;
  const SeveralBooksHome(
      {Key? key, required this.currentUser, required this.currentGroup})
      : super(key: key);

  @override
  _SeveralBooksHomeState createState() => _SeveralBooksHomeState();
}

class _SeveralBooksHomeState extends State<SeveralBooksHome> {
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
    if (widget.currentGroup.hasBooks == false) {
      return Container(
        width: MediaQuery.of(context).size.width * 90 / 100,
        child: Column(
          children: [
            HomeBookSection(
              widget: widget,
              title: "empruntables",
              barWidth: 145,
            ),
            HomeBookSection(
              widget: widget,
              title: "en circulation",
              barWidth: 145,
            ),
            HomeBookSection(
              widget: widget,
              title: "que vous avez empruntés",
              barWidth: 275,
            ),
            HomeBookSection(
              widget: widget,
              title: "que vous avez prêtés",
              barWidth: 225,
            ),
          ],
        ),
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
            const SizedBox(
              height: 20,
            ),
            Text(
              'Pour inviter des membres à vous joindre, envoyez-leur le code du groupe qui se trouve dans l\'onglet "Groupe"',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdminGroup(
                        currentGroup: widget.currentGroup,
                        currentUser: widget.currentUser),
                  ));
                },
                child: Text(
                  "Aller à l'onglet Groupe",
                  style: TextStyle(color: Theme.of(context).focusColor),
                ))
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
            Container(
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
                    child: Row(
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
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.currentUser.pseudo![0].toUpperCase()}${widget.currentUser.pseudo!.substring(1)}",
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _displayHomeWidget()
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
}

class HomeBookSection extends StatelessWidget {
  const HomeBookSection(
      {Key? key,
      required this.widget,
      required this.title,
      required this.barWidth})
      : super(key: key);

  final SeveralBooksHome widget;
  final String? title;
  final double? barWidth;
  // final SeveralBooksHome widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
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
            Text(
              title!,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
        Container(
          transform: Matrix4.translationValues(0, -27, 0),
          child: Row(
            children: [
              SizedBox(
                width: 70,
              ),
              ColorBar(
                barWidth: barWidth,
              )
            ],
          ),
        ),
        Container(
          //color: Colors.blueGrey,
          transform: Matrix4.translationValues(0, -28, 0),
          child: BookSection(
              currentGroup: widget.currentGroup,
              currentUser: widget.currentUser,
              sectionCategory: title!),
        ),
        Container(
          transform: Matrix4.translationValues(0, -28, 0),
          child: ElevatedButton(
            onPressed: () {},
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
