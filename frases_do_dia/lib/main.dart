import 'package:flutter/material.dart';

void onPressed(){
  print("Botão pressionado!");
}

void main (){

  runApp(MaterialApp(
    title: 'Frase do dia',
    home: Container(
      color: Colors.white,
      child: Column(
        children: const [
          FlatButton(
            onPressed: onPressed,
            child: Text(
                "Clique aqui!",
                 style: TextStyle(
                   fontSize: 20,
                   color: Colors.black,
                   decoration: TextDecoration.none
                 ),
            )
          )
        ],
      ),
    )
  ));

}