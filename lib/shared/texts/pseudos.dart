import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../models/user_model.dart';
import '../../services/db_stream.dart';

String userPseudo(UserModel user) {
  return "${user.pseudo![0].toUpperCase()}${user.pseudo!.substring(1)}";
}

Widget displayBorrowerPseudo(
    BuildContext context, BookModel currentBook, Color color) {
  if (currentBook.lenderId == null) {
    return Text(
      "personne",
      style: TextStyle(color: color),
    );
  } else {
    return StreamBuilder<UserModel>(
        stream: DBStream().getUserData(currentBook.lenderId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (!snapshot.hasData) {
            return Text("personne");
          } else {
            UserModel _user = snapshot.data!;
            return Text(
              userPseudo(_user),
              style: TextStyle(color: color),
            );
          }
        });
  }
}
