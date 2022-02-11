import 'package:flutter/material.dart';

Color? cream = Colors.amber[50];
Color? cherry = Colors.red[300];
Color? brown = Colors.brown[600];

class AppTheme {
  ThemeData buildTheme() {
    return ThemeData(
      //colors
      canvasColor: cream,
      primaryColor: Colors.grey,
      focusColor: cherry,
      shadowColor: brown,

      //texts
      textTheme: const TextTheme(
        bodyText2: TextStyle(
            color: Colors.brown, fontSize: 20, fontWeight: FontWeight.bold),
      ),

      //buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: Colors.red[300]),
      ),

      //forms
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: cream!)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: cherry!)),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: brown!),
        ),
        iconColor: cherry,
        labelStyle: TextStyle(color: cherry!),
        errorStyle: TextStyle(color: brown!),
      ),
    );
  }
}
