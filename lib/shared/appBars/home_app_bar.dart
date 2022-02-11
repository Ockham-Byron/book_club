import 'package:book_club/services/auth.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).shadowColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await _auth.signOut();
          },
        ),
      ],
    );
  }
}
