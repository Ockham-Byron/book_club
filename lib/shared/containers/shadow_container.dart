import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  const ShadowContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 90 / 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(0, 3),
              )
            ]),
        child: child,
      ),
    );
  }
}
