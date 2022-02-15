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

  // @override
  // void didChangeDependencies() {
  //   String _pickingUserId;
  //   if (widget.currentGroup.members != null) {
  //     _pickingUserId =
  //         widget.currentGroup.members![widget.currentGroup.indexPickingBook!];
  //   } else {
  //     _pickingUserId = widget.currentGroup.leader!;
  //   }
  //   _pickingUser = DBStream().getUserData(_pickingUserId) as UserModel;
  //   print("picking user " + _pickingUser.pseudo!);

  //   super.didChangeDependencies();
  // }

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
    print(widget.currentGroup.id);
    List<String> members = [];
    if (widget.currentGroup.members != null) {
      members = widget.currentGroup.members!;
    } else {
      members = [widget.currentGroup.leader ?? ""];
    }
    return StreamBuilder<UserModel>(
        stream: DBStream().getUserData(widget
            .currentGroup.members![widget.currentGroup.indexPickingBook!]),
        builder: (context, snapshot) {
          UserModel _pickingUser = snapshot.data!;
          Widget passerTour;

          if (widget.currentGroup.members != null) {
            if (widget.currentGroup.members!.length <= 1) {
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
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).focusColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                passerTour,
              ],
            );
          } else {
            String _pickingUserPseudo =
                _pickingUser.pseudo ?? "pas encore déterminé";
            return Column(
              children: [
                Text(
                  "Prochain livre à choisir par",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${_pickingUserPseudo[0].toUpperCase()}${_pickingUserPseudo.substring(1)}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ],
            );
          }
        });
  }
}
