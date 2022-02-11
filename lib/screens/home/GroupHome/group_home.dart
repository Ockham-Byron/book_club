import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/home/GroupHome/single_book_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupHome extends StatefulWidget {
  final UserModel currentUser;

  const GroupHome({Key? key, required this.currentUser}) : super(key: key);

  @override
  _GroupHomeState createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {
  @override
  Widget build(BuildContext context) {
    GroupModel currentGroup = Provider.of<GroupModel>(context);
    return SingleBookHome(
      currentUser: widget.currentUser,
      currentGroup: currentGroup,
    );
  }
}
