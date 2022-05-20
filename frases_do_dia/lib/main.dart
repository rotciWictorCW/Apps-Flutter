import 'package:flutter/material.dart';

void onPressed(){
  print("Botão pressionado!");
}

void main (){

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Frases do dia"),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text("conteúdo princioal"),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                const Text('Conteúdo princioal'),
                const Text('Outro Conteúdo'),

              ],
            ),
        )

      ),
    ),
  ));

}