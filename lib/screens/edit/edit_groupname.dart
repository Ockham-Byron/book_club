import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/admin/admin_group.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:flutter/material.dart';

import '../../models/group_model.dart';

class EditGroupName extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  const EditGroupName(
      {Key? key, required this.currentGroup, required this.currentUser})
      : super(key: key);

  @override
  _EditGroupNameState createState() => _EditGroupNameState();
}

class _EditGroupNameState extends State<EditGroupName> {
  FocusNode? fgrname;
  String? initialName;

  @override
  void initState() {
    initialName = widget.currentGroup.name!;
    _groupNameInput.text = initialName!;
    super.initState();
  }

  void _editGroupName(String groupId, String groupName) async {
    String _message;

    _message =
        await DBFuture().editGroupName(groupId: groupId, groupName: groupName);

    if (_message == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AdminGroup(
              currentGroup: widget.currentGroup,
              currentUser: widget.currentUser)));
    }
  }

  final TextEditingController _groupNameInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ShadowContainer(
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
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: "Nom du groupe",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _editGroupName(
                          widget.currentGroup.id!, _groupNameInput.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Modifier".toUpperCase(),
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
    );
  }
}
