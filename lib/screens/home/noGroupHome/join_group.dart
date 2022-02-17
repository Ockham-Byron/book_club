import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/appBars/home_app_bar.dart';
import 'package:book_club/shared/background_container.dart';
import 'package:book_club/shared/shadow_container.dart';
import 'package:flutter/material.dart';

class JoinGroup extends StatefulWidget {
  final UserModel userModel;
  const JoinGroup({Key? key, required this.userModel}) : super(key: key);

  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  FocusNode? fid;

  void _joinGroup(BuildContext context, String groupId) async {
    UserModel _currentUser = widget.userModel;
    print(_currentUser.uid);
    String _returnString =
        await DBFuture().joinGroup(groupId: groupId, userId: _currentUser.uid!);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AppRoot(),
        ),
        (route) => false);
  }

  final TextEditingController _groupIdInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: BackgroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ShadowContainer(
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                        autofocus: true,
                        focusNode: fid,
                        onTap: () {
                          setState(() {
                            FocusScope.of(context).requestFocus(fid);
                          });
                        },
                        textInputAction: TextInputAction.next,
                        controller: _groupIdInput,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.group,
                            color: Theme.of(context).focusColor,
                          ),
                          labelText: "code du groupe",
                          labelStyle:
                              TextStyle(color: Theme.of(context).focusColor),
                        ),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _joinGroup(context, _groupIdInput.text);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Joindre le groupe".toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
