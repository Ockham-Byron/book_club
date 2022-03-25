import 'package:flutter/material.dart';

double mobileMaxWidth = 420;
double mobileContainerMaxWidth = 380;
double mobileContainerMaxHeight = 800;

Widget computerLayout(Widget widget) {
  return Center(
      child: SizedBox(
    height: mobileContainerMaxHeight,
    width: mobileMaxWidth,
    child: widget,
  ));
}
