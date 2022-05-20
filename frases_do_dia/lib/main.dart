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
      child: Column( // flex-direction
        mainAxisAlignment: MainAxisAlignment.center, // justify-content
        crossAxisAlignment: CrossAxisAlignment.center, // align-itens
        children: const [
          Text("T1"),
          Text("T2"),
          Text("T3")
        ],
      ),
    )
  ));

}