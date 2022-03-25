import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Annuler".toUpperCase(),
          style: TextStyle(color: Theme.of(context).focusColor),
        ));
  }
}
