import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/shadow_container.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

class AddReview extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  final String bookId;
  final Widget fromRoute;

  const AddReview(
      {Key? key,
      required this.currentGroup,
      required this.currentUser,
      required this.bookId,
      required this.fromRoute})
      : super(key: key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final reviewKey = GlobalKey<ScaffoldState>();
  int _dropdownValue = 1;
  //AuthModel _authModel = AuthModel();
  //late BookModel _reviewedBook = BookModel();
  bool favorite = false;
  final TextEditingController _reviewInput = TextEditingController();
  FocusNode? freview;

  // @override
  // void didChangeDependencies() async {
  //   //_authModel = Provider.of<AuthModel>(context);
  //   _reviewedBook =
  //       await DBFuture().getBook(widget.bookId, widget.currentGroup.id!);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: reviewKey,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Evaluez le livre de 1 à 10",
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).focusColor),
              ),
              DropdownButton<int>(
                  value: _dropdownValue,
                  icon: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).focusColor,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).focusColor),
                  underline: Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 2,
                    color: Theme.of(context).focusColor,
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      _dropdownValue = newValue!;
                    });
                  },
                  items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ShadowContainer(
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    focusNode: freview,
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).requestFocus(freview);
                      });
                    },
                    textInputAction: TextInputAction.next,
                    controller: _reviewInput,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: "Votre critique",
                      labelStyle:
                          TextStyle(color: Theme.of(context).canvasColor),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Ce livre fait-il partie de vos favoris ?"),
              const SizedBox(width: 20),
              FavoriteButton(
                iconColor: Theme.of(context).focusColor,
                isFavorite: false,
                valueChanged: (_isFavorite) {
                  print('Is Favorite : $_isFavorite');
                  if (_isFavorite = false) {
                    favorite = false;
                  } else {
                    favorite = true;
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              if (favorite == true) {
                DBFuture().favoriteBook(widget.currentGroup.id!, widget.bookId,
                    widget.currentUser.uid!);
              }
              DBFuture().reviewBook(
                  widget.currentGroup.id!,
                  widget.bookId,
                  widget.currentUser.uid!,
                  _dropdownValue,
                  _reviewInput.text,
                  favorite);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.fromRoute,
                ),
                (route) => false,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Envoyer votre critique".toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
