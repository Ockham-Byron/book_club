import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/home/noGroupHome/no_group_home.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/appBars/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final UserModel? currentUser;
  const Home({Key? key, required this.currentUser}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HomeAppBar(),
        body: StreamProvider<UserModel>.value(
          value: DBStream().getUserData(widget.currentUser!.uid!),
          initialData: UserModel(),
          child: const NoGroup(),
        ));
  }
}
