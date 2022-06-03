import 'package:flutter/material.dart';

class Emalta extends StatefulWidget {
  const Emalta({Key? key}) : super(key: key);

  @override
  State<Emalta> createState() => _EmaltaState();
}

class _EmaltaState extends State<Emalta> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Text(
            "Em Alta",
          ),
        )
    );
  }
}
