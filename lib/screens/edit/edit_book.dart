import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/services/db_stream.dart';
import 'package:book_club/shared/background_container.dart';
import 'package:book_club/shared/loading.dart';
import 'package:book_club/shared/shadow_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EditBook extends StatefulWidget {
  final GroupModel currentGroup;
  final BookModel currentBook;
  final UserModel currentUser;
  //final AuthModel authModel;
  final String fromScreen;

  const EditBook(
      {Key? key,
      required this.currentGroup,
      required this.currentBook,
      required this.currentUser,
      //required this.authModel,
      required this.fromScreen})
      : super(key: key);

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  String? initialTitle;
  String? initialAuthor;
  int? initialPages;
  String? initialBookCover;
  Timestamp? initialDate;
  DateTime? _selectedDate;

  @override
  void initState() {
    initialTitle = widget.currentBook.title;
    initialAuthor = widget.currentBook.author;
    initialPages = widget.currentBook.length;
    initialBookCover = widget.currentBook.cover;
    initialDate = widget.currentBook.dueDate;
    _selectedDate = initialDate!.toDate();
    _bookTitleInput.text = initialTitle!;
    _bookAuthorInput.text = initialAuthor!;
    _bookLengthInput.text = initialPages!.toString();
    _bookCoverInput.text = initialBookCover!;

    super.initState();
  }

  final TextEditingController _bookTitleInput = TextEditingController();
  final TextEditingController _bookAuthorInput = TextEditingController();
  final TextEditingController _bookLengthInput = TextEditingController();
  final TextEditingController _bookCoverInput = TextEditingController();

  //DateTime _selectedDate = DateTime.now();
  //DateTime? _selectedDate = initialDate?.toDate();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked =
        (await DatePicker.showDateTimePicker(context, showTitleActions: true))!;
    setState(() {
      _selectedDate = picked;
    });
  }

  void _editBook(
      String groupId,
      String bookId,
      String bookTitle,
      String bookAuthor,
      String bookCover,
      int bookPages,
      Timestamp dateCompleted) async {
    String _returnString;

    _returnString = await DBFuture().editBook(
      groupId: groupId,
      bookId: bookId,
      bookTitle: bookTitle,
      bookAuthor: bookAuthor,
      bookCover: bookCover,
      bookPages: bookPages,
      dueDate: dateCompleted,
    );

    if (_returnString == "success" && widget.fromScreen == "fromHome") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AppRoot()));
    } else if (_returnString == "success" &&
        widget.fromScreen == "fromHistory") {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => BookHistory(
      //           groupId: widget.currentGroup.id!,
      //           groupName: widget.currentGroup.name!,
      //           currentGroup: widget.currentGroup,
      //           currentUser: widget.currentUser,
      //           currentBook: widget.currentBook,
      //           authModel: widget.authModel,
      //         )));
    }
  }

  @override
  Widget build(BuildContext context) {
    //UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      body: BackgroundContainer(
        child: ShadowContainer(
          child: Column(
            children: [
              TextFormField(
                controller: _bookTitleInput,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).canvasColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  prefixIcon: Icon(
                    Icons.book,
                    color: Theme.of(context).primaryColor,
                  ),
                  labelText: "Titre du livre",
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _bookAuthorInput,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).canvasColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  prefixIcon: Icon(
                    Icons.face,
                    color: Theme.of(context).primaryColor,
                  ),
                  labelText: "Auteur.e du livre",
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _bookLengthInput,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).canvasColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  prefixIcon: Icon(
                    Icons.format_list_numbered,
                    color: Theme.of(context).primaryColor,
                  ),
                  labelText: "Nombre de pages",
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _bookCoverInput,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).canvasColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  prefixIcon: Icon(
                    Icons.auto_stories,
                    color: Theme.of(context).primaryColor,
                  ),
                  labelText: "Url de la couverture du livre",
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Rdv pour échanger sur ce livre le",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(DateFormat("dd/MM à HH:mm").format(_selectedDate!),
                  style: Theme.of(context).textTheme.headline6),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _editBook(
                      widget.currentGroup.id!,
                      widget.currentBook.id!,
                      _bookTitleInput.text,
                      _bookAuthorInput.text,
                      _bookCoverInput.text,
                      int.parse(_bookLengthInput.text),
                      Timestamp.fromDate(_selectedDate!));
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
    );
  }
}
