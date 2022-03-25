import 'package:book_club/models/suggestion_model.dart';
import 'package:book_club/models/user_model.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/loading.dart';
import 'package:flutter/material.dart';

class SuggestionCard extends StatefulWidget {
  final UserModel currentUser;
  final SuggestionModel suggestion;
  const SuggestionCard(
      {Key? key, required this.suggestion, required this.currentUser})
      : super(key: key);

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  Widget _displayUserInfo() {
    if (widget.suggestion.isAnonymous!) {
      return const Text("Suggestion d'un.e anonyme");
    } else {
      return StreamBuilder<UserModel>(
          stream: DBStream().getUserData(widget.suggestion.userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              UserModel _user = snapshot.data!;
              String pseudo;
              if (_user.uid == widget.currentUser.uid) {
                pseudo = "moi";
              } else {
                pseudo =
                    "${_user.pseudo![0].toUpperCase()}${_user.pseudo!.substring(1)}";
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Suggestion proposée par "),
                  Text(
                    pseudo,
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ),
                ],
              );
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SuggestionModel>(
        stream: DBStream().getSuggestionData(widget.suggestion.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            SuggestionModel _suggestion = snapshot.data!;

            // bool hasSupported;
            // if (_suggestion.supportedBy!.contains(widget.currentUser)) {
            //   hasSupported =true ;
            //   print("a déjà voté");
            // } else {
            //   hasSupported = false;
            //   print("n'a pas encore voté");
            // }
            return Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _displayUserInfo(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.black,
                    width: 100,
                    height: 3,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(_suggestion.suggestion!),
                  const SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   color: Colors.black,
                  //   width: 100,
                  //   height: 3,
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   children: [
                  //     const Text("Je soutiens cette proposition : "),
                  //     Badge(
                  //       badgeColor: Theme.of(context).focusColor,
                  //       badgeContent: Text(widget.suggestion.votes.toString()),
                  //       child: IconButton(
                  //           onPressed: () async {
                  //             await DBFuture().voteForSuggestion(
                  //                 _suggestion.id!, widget.currentUser.uid!);

                  //             print("a voté");
                  //             setState(() {
                  //               iconColor = Colors.green;
                  //             });
                  //           },
                  //           icon: Icon(
                  //             Icons.thumb_up,
                  //             color: iconColor,
                  //           )),
                  //     )
                  //   ],
                  // )
                ],
              ),
            );
          }
        });
  }
}
