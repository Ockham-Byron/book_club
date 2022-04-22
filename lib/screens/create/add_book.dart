import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/root.dart';
import 'package:book_club/services/db_future.dart';
import 'package:book_club/shared/constraints.dart';

import 'package:book_club/shared/containers/background_container.dart';
import 'package:book_club/shared/containers/shadow_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../shared/custom_form_field.dart';

class AddBook extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel currentUser;
  const AddBook(
      {Key? key, required this.currentGroup, required this.currentUser})
      : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  //key for the form's validation
  final _formKey = GlobalKey<FormState>();

  //focus
  FocusNode? ftitle;
  FocusNode? fauthor;
  FocusNode? flength;
  FocusNode? fcover;

  //controllers of inputs
  final TextEditingController _bookTitleInput = TextEditingController();
  final TextEditingController _bookAuthorInput = TextEditingController();
  final TextEditingController? _bookLengthInput = TextEditingController();
  final TextEditingController _bookCoverInput = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked =
        (await DatePicker.showDateTimePicker(context, showTitleActions: true))!;
    setState(() {
      _selectedDate = picked;
    });
  }

  //function to add the book to a single book group
  void _addSingleBook(
      BuildContext context, String groupId, BookModel book) async {
    String _message;

    int _nbOfMembers = widget.currentGroup.members!.length;
    int? _actualPicker = widget.currentGroup.indexPickingBook;
    int _nextPicker;
    if (_actualPicker == (_nbOfMembers - 1)) {
      _nextPicker = 0;
    } else {
      _nextPicker = (_actualPicker! + 1);
    }

    _message = await DBFuture()
        .addSingleBook(widget.currentGroup.id!, book, _nextPicker);

    if (_message == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AppRoot(),
          ),
          (route) => false);
    }
  }

  //function to add the book to a several books group
  void _addBook(BuildContext context, String groupId, BookModel book) async {
    String _message;

    _message = await DBFuture().addBook(widget.currentGroup.id!, book);

    if (_message == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AppRoot(),
          ),
          (route) => false);
    }
  }

  //display the timepicker
  Widget _displayTimePicker() {
    if (widget.currentGroup.isSingleBookGroup == true) {
      return Column(
        children: [
          Text(
            "Rdv pour échanger sur ce livre",
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(DateFormat("dd/MM à HH:mm").format(_selectedDate),
              style: Theme.of(context).textTheme.headline6),
          TextButton(
            onPressed: () => _selectDate(context),
            child: Icon(
              Icons.calendar_today,
              color: Theme.of(context).focusColor,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  //Alert popup show url explanation
  Future<void> _showUrlExplanation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Text(
            "Comment récupérer l'url de la couverture du livre ?",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Trouvez une photo de la couverture sur internet.'),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    "Si vous êtes sur un mobile, appuyez longuement sur l'image. Sur un ordinateur, faites un clic droit."),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    'Dans la liste d\'options, choisissez "copier le lien".'),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    'Collez ce lien dans le champ "url de la couverture du livre".'),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('X',
                  style: TextStyle(color: Theme.of(context).focusColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                child: globalLayout(context)),
          );
        } else {
          return globalLayout(context);
        }
      },
    );
  }

  Scaffold globalLayout(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ShadowContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormField(
                            focusNode: ftitle,
                            hintText: "Titre du livre",
                            iconData: Icons.book,
                            textEditingController: _bookTitleInput,
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
                            focusNode: fauthor,
                            textEditingController: _bookAuthorInput,
                            iconData: Icons.face,
                            hintText: "Auteur.e du livre",
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Merci d'indiquer l'auteur du livre";
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomFormField(
                          keyboardType: TextInputType.number,
                          focusNode: flength,
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
                          focusNode: fcover,
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
                        TextButton(
                            onPressed: () => _showUrlExplanation(),
                            child: Text(
                              "Comment récupérer l'url de la couverture du livre ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).shadowColor),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        _displayTimePicker(),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              int bookLength;
                              if (_bookLengthInput!.text == "") {
                                bookLength = 0;
                              } else {
                                bookLength = int.parse(_bookLengthInput!.text);
                              }
                              BookModel? book = BookModel(
                                  title: _bookTitleInput.text,
                                  author: _bookAuthorInput.text,
                                  length: bookLength,
                                  cover: _bookCoverInput.text,
                                  submittedBy: widget.currentUser.uid,
                                  ownerId: widget.currentUser.uid,
                                  isLendable: true,
                                  lenderId: null,
                                  dueDate: Timestamp.fromDate(_selectedDate));
                              if (widget.currentGroup.id != null) {
                                if (widget.currentGroup.isSingleBookGroup ==
                                    true) {
                                  _addSingleBook(
                                      context, widget.currentGroup.id!, book);
                                } else {
                                  _addBook(
                                      context, widget.currentGroup.id!, book);
                                }
                              } else {
                                // print(widget.currentGroup);
                                // print("pas de groupId");
                              }
                            }
                          },
                          child: Text(
                            "Ajoutez le livre".toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Annuler".toUpperCase(),
                              style: TextStyle(
                                  color: Theme.of(context).focusColor)),
                        )
                      ],
                    ),
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
