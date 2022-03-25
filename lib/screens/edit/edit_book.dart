import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/screens/history/book_detail.dart';
import 'package:book_club/screens/history/book_history.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/appBars/home_app_bar.dart';
import 'package:book_club/shared/constraints.dart';

import 'package:book_club/shared/containers/background_container.dart';

import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../shared/custom_form_field.dart';

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
  //key for the form's validation
  final _formKey = GlobalKey<FormState>();

  //initial values
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BookHistory(
                currentGroup: widget.currentGroup,
                currentUser: widget.currentUser,
              )));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BookDetail(
                currentGroup: widget.currentGroup,
                currentUser: widget.currentUser,
                currentBook: widget.currentBook,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileMaxWidth) {
          return Center(
            child: SizedBox(
              height: mobileContainerMaxHeight,
              width: mobileMaxWidth,
              child: globalWidget(context),
            ),
          );
        } else {
          return globalWidget(context);
        }
      },
    );
  }

  Scaffold globalWidget(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(top: 50),
              height: 700,
              child: ShadowContainer(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomFormField(
                          textEditingController: _bookTitleInput,
                          iconData: Icons.book,
                          hintText: "Titre du livre",
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Merci d'indiquer le titre du livre";
                            } else {
                              return null;
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormField(
                          textEditingController: _bookAuthorInput,
                          iconData: Icons.face,
                          hintText: "Auteur.e du livre",
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Merci d'indiquer l'auteur.e du livre";
                            } else {
                              return null;
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormField(
                        keyboardType: TextInputType.number,
                        textEditingController: _bookLengthInput,
                        iconData: Icons.format_list_numbered,
                        hintText: "Nombre de pages",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormField(
                        textEditingController: _bookCoverInput,
                        iconData: Icons.auto_stories,
                        hintText: "Url de la couverture du livre",
                        validator: (val) {
                          if (val!.isValidImageUrl || val == "") {
                            return null;
                          } else {
                            return 'Url non valide.Y a-t-il un .png ou .jpg à la fin ? Si vous ne souhaitez pas ajouter de photo de profil, laissez vide';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Rdv pour échanger sur ce livre le",
                        style: TextStyle(
                            color: Theme.of(context).focusColor, fontSize: 20),
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
                          color: Theme.of(context).focusColor,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _editBook(
                                widget.currentGroup.id!,
                                widget.currentBook.id!,
                                _bookTitleInput.text,
                                _bookAuthorInput.text,
                                _bookCoverInput.text,
                                int.parse(_bookLengthInput.text),
                                Timestamp.fromDate(_selectedDate!));
                          }
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
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Annuler".toUpperCase(),
                            style:
                                TextStyle(color: Theme.of(context).focusColor)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
