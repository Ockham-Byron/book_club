import 'package:book_club/shared/appBars/home_app_bar.dart';
import 'package:flutter/material.dart';

class SingleBookHome extends StatefulWidget {
  const SingleBookHome({Key? key}) : super(key: key);

  @override
  _SingleBookHomeState createState() => _SingleBookHomeState();
}

class _SingleBookHomeState extends State<SingleBookHome> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: Center(
        child: Text("Single Book Home"),
      ),
    );
  }
}
