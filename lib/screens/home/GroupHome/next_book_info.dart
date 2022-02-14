import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/screens/create/add_book.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:flutter/material.dart';

class NextBookInfo extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  const NextBookInfo(
      {Key? key, required this.currentGroup, required this.currentUser})
      : super(key: key);

  @override
  _NextBookInfoState createState() => _NextBookInfoState();
}

class _NextBookInfoState extends State<NextBookInfo> {
  UserModel _pickingUser = UserModel();

  void _goToAddNextBook() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddBook(
          currentGroup: widget.currentGroup,
          //currentUser: _pickingUser,
        ),
      ),
    );
  }

  void _changePickingUser() async {
    if (widget.currentGroup.indexPickingBook! <
        widget.currentGroup.members!.length - 1) {
      DBFuture().changePicker(widget.currentGroup.id!);
    } else {
      DBFuture().changePickerFromStart(widget.currentGroup.id!);
    }
    UserModel _newPickingUser = DBStream().getUserData(
            widget.currentGroup.members![widget.currentGroup.indexPickingBook!])
        as UserModel;
    setState(() {
      _pickingUser = _newPickingUser;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const AppRoot(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget passerTour;
    if (widget.currentGroup.members != null) {
      if (widget.currentGroup.members!.length <= 1) {
        passerTour = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Theme.of(context).primaryColor,
              shape: const CircleBorder(),
              onPressed: () => _goToAddNextBook(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.add),
              ),
            ),
          ],
        );
      } else {
        passerTour = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Theme.of(context).focusColor,
              shape: const CircleBorder(),
              onPressed: () => _goToAddNextBook(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.add),
              ),
            ),
            TextButton(
                onPressed: () => _changePickingUser(),
                child: Text(
                  "Je préfère passer mon tour",
                  style: TextStyle(color: Theme.of(context).focusColor),
                ))
          ],
        );
      }
    } else {
      passerTour = Container();
    }

    if (_pickingUser.uid == widget.currentUser.uid) {
      return Column(
        children: [
          Text(
            "C'est à ton tour de choisir le prochain livre",
            style:
                TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          passerTour,
        ],
      );
    } else {
      String _pickingUserPseudo = _pickingUser.pseudo ?? "pas encore déterminé";
      return Column(
        children: [
          const Text(
            "Prochain livre à choisir par",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${_pickingUserPseudo[0].toUpperCase()}${_pickingUserPseudo.substring(1)}",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      );
    }
  }
}
