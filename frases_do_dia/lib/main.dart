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
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      margin: EdgeInsets.only(top:50),
      decoration: BoxDecoration(
        border: Border.all(width: 5,color: Colors.deepPurple)
      ),
      child: Row(
        children: const [
          Text("T1"),

          Padding(
              padding: EdgeInsets.all(50),
              child:Text("T2"),
          ),


          Text("T3")
          /*Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sed elit nec quam laoreet efficitur.",
              textAlign: TextAlign.justify,
          )*/
        ],
      ),
    )
  ));

}