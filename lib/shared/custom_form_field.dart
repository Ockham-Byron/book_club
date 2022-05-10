import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.hintText,
    this.iconData,
    this.focusNode,
    this.textEditingController,
    this.inputFormatters,
    this.validator,
    this.keyboardType,
  }) : super(key: key);
  final String hintText;
  final IconData? iconData;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        controller: textEditingController,
        decoration: InputDecoration(
            labelText: hintText, prefixIcon: Icon(iconData), errorMaxLines: 3),
      ),
    );
  }
}

extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9_.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[?!@#\$&*~]).{8,}$');

    return passwordRegExp.hasMatch(this);
  }

  bool get isValidImageUrl {
    final imageUrlRegExp = RegExp(
        r'^(?:([^:/?#]+):)?(?://([^/?#]*))?([^?#]*\.(?:jpg|jpeg|png))(?:\?([^#]*))?(?:#(.*))?');
    return imageUrlRegExp.hasMatch(this);
  }
}
