import 'package:badges/badges.dart';
import 'package:book_club/models/suggestion_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:flutter/material.dart';

class SuggestionCard extends StatefulWidget {
  final SuggestionModel suggestion;
  const SuggestionCard({
    Key? key,
    required this.suggestion,
  }) : super(key: key);

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  bool voted = false;

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
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Suggestion proposée par "),
                  Text(
                    "${_user.pseudo![0].toUpperCase()}${_user.pseudo!.substring(1)}",
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
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _displayUserInfo(),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.black,
            width: 100,
            height: 3,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(widget.suggestion.suggestion!),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.black,
            width: 100,
            height: 3,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("Je soutiens cette proposition : "),
              Badge(
                badgeColor: Theme.of(context).focusColor,
                badgeContent: Text(widget.suggestion.votes.toString()),
                child: IconButton(
                    onPressed: () async {
                      if (voted = false) {
                        await DBFuture()
                            .voteForSuggestion(widget.suggestion.id!);
                        setState(() {
                          voted != voted;
                        });
                        print("a voté");
                      } else {
                        await DBFuture()
                            .cancelVoteForSuggestion(widget.suggestion.id!);
                        setState(() {
                          voted != voted;
                        });
                        print("annulé");
                      }
                    },
                    icon: Icon(
                      Icons.thumb_up,
                      color:
                          voted ? Theme.of(context).focusColor : Colors.black,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
