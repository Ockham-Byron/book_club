import 'package:book_club/models/auth_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';

import 'package:book_club/screens/authenticate/login.dart';
import 'package:book_club/screens/home/GroupHome/group_home.dart';
import 'package:book_club/screens/home/noGroupHome/no_group_home.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/loading.dart';
import 'package:book_club/shared/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//define if user is loggedIn or not
enum AuthStatus { unknown, notLoggedIn, loggedIn }

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  AuthStatus _authStatus = AuthStatus.unknown;
  String? currentUid;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    //get the state, check current user, set Authstatus based on state
    AuthModel? _authStream = Provider.of<AuthModel?>(context);
    if (_authStream != null) {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
        currentUid = _authStream.uid;
      });
      //print("logged in");
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
      //print("not loggedIn");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_authStatus == AuthStatus.notLoggedIn) {
      return const LogIn();
    } else if (_authStatus == AuthStatus.loggedIn) {
      if (currentUid != null) {
        print("root currentUid : " + currentUid.toString());
        return StreamProvider<UserModel>.value(
          //catchError: (_, error) => UserModel(),
          value: DBStream().getUserData(currentUid!),
          initialData: UserModel(),
          child: const LoggedIn(),
        );
      } else {
        return const Loading();
      }
    } else {
      return SplashScreen();
    }
  }
}

class LoggedIn extends StatelessWidget {
  const LoggedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _userStream = Provider.of<UserModel>(context);

    Widget displayScreen;

    if (_userStream.groupId != null) {
      print("user a un groupId");
      displayScreen = StreamProvider<GroupModel>.value(
        value: DBStream().getGroupData(_userStream.groupId!),
        initialData: GroupModel(),
        child: GroupHome(
          currentUser: _userStream,
        ),
      );
    } else {
      displayScreen = const NoGroup();
    }

    return displayScreen;
  }
}
