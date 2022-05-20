import 'package:flutter/material.dart';

void onPressed(){
  print("Botão pressionado!");
}

void main (){

  runApp(MaterialApp(
    //debugShowCheckedModeBanner: false,
    title: 'Frase do dia',
    home: Container(
      //color: Colors.white,
      margin: EdgeInsets.only(top:40),
      decoration: BoxDecoration(
        border: Border.all(width: 3,color: Colors.deepPurple)
      ),
      child: Image.asset(
          "images/parque.jpg",
          fit: BoxFit.fitWidth,

      )
    )
  ));

}