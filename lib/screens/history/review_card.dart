import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/review_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  final ReviewModel review;
  final UserModel currentUser;
  final GroupModel currentGroup;
  final BookModel book;

  ReviewCard({
    required this.review,
    required this.currentUser,
    required this.currentGroup,
    required this.book,
  });

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  // UserModel user = UserModel();

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   user = await DBFuture().getUser(widget.review.userId!);
  //   setState(() {});
  // }

  void _goToEditReview() {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => EditReview(
    //           currentGroup: widget.currentGroup,
    //           book: widget.book,
    //           currentReview: widget.review,
    //           currentUser: widget.currentUser,
    //           authModel: widget.authModel,
    //         )));
  }

  //Widget _editWidget() {
  // if (widget.currentUser.uid! == widget.review.reviewId) {
  //   return GestureDetector(
  //     onTap: () => _goToEditReview(),
  //     child: Icon(
  //       Icons.edit,
  //       color: Theme.of(context).primaryColor,
  //     ),
  //   );
  // } else {
  //   return Container();
  // }
  //}

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                (widget.currentUser.uid != null)
                    ? widget.currentUser.pseudo!
                    : "pas de nom ?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
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
          // _editWidget(),
        ],
      ),
    );
  }
}
