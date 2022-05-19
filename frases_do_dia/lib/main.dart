import 'package:flutter/material.dart';

void main (){

  runApp(MaterialApp(
    title: 'Frase do dia',
    home: Container(
      color: Colors.white,
      child: Column(
        children: const [
          Text(
              "Lorem ipsum",
            style: TextStyle(
              fontSize: 35,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              letterSpacing: 0,
              wordSpacing: 0,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.lightGreenAccent,
              decorationStyle: TextDecorationStyle.solid,
              color: Colors.black
            ),
          )
        ],
      ),
    )
  ));

}