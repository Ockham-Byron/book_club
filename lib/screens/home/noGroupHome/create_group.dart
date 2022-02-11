import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/services/auth.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/appBars/home_app_bar.dart';
import 'package:book_club/shared/background_container.dart';
import 'package:book_club/shared/shadow_container.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  final UserModel currentUser;
  const CreateGroup({Key? key, required this.currentUser}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  FocusNode? fgrname;

  void _createGroup(String groupName, UserModel user) async {
    String _returnString;

    _returnString = await DBFuture().createGroup(groupName, user);

    if (_returnString == "success") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AppRoot()));
    }
  }

  final TextEditingController _groupNameInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: BackgroundContainer(
        child: Center(
          child: Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ShadowContainer(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      autofocus: true,
                      focusNode: fgrname,
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(fgrname);
                        });
                      },
                      textInputAction: TextInputAction.next,
                      controller: _groupNameInput,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.group,
                          color: Theme.of(context).focusColor,
                        ),
                        labelText: "Nom du groupe",
                        labelStyle:
                            TextStyle(color: Theme.of(context).focusColor),
                      ),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        UserModel currentUser = widget.currentUser;

                        _createGroup(_groupNameInput.text, currentUser);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Créez le groupe".toUpperCase(),
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
        ),
      ),
    );
  }
}
