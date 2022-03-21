import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/review_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/screens/edit/edit_review.dart';

import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  final ReviewModel review;
  final UserModel currentUser;
  final GroupModel currentGroup;
  final BookModel book;

  const ReviewCard({
    Key? key,
    required this.review,
    required this.currentUser,
    required this.currentGroup,
    required this.book,
  }) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  void _goToEditReview() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditReview(
              currentGroup: widget.currentGroup,
              book: widget.book,
              currentReview: widget.review,
              currentUser: widget.currentUser,
            )));
  }

  Widget _editWidget() {
    if (widget.currentUser.uid! == widget.review.reviewId) {
      return GestureDetector(
        onTap: () => _goToEditReview(),
        child: Icon(
          Icons.edit,
          color: Theme.of(context).focusColor,
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Row(
        children: [
          Column(
            children: [
              StreamBuilder<UserModel>(
                  stream: DBStream().getUserData(widget.review.reviewId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel _user = snapshot.data!;
                      return Text(
                        (_user.uid != null) ? _user.pseudo! : "pas de nom ?",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      );
                    } else {
                      return Container();
                    }
                  }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                child: Text(
                  "Note : " + widget.review.rating.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).focusColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80,
            child: VerticalDivider(
              thickness: 1,
              width: 10,
              color: Theme.of(context).focusColor,
            ),
          ),
          (widget.review.review != null)
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.review.review!,
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).primaryColor),
                    ),
                  ),
                )
              : const Text(""),
          _editWidget(),
        ],
      ),
    );
  }
}
