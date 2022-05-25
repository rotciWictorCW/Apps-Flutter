import 'dart:math';
import 'package:flutter/material.dart';

void main (){

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeStateful(),
  ));
}

class HomeStateful extends StatefulWidget {
  const HomeStateful({Key? key}) : super(key: key);

  @override
  State<HomeStateful> createState() => _HomeStatefulState();
}

class _HomeStatefulState extends State<HomeStateful> {

  String _title = "Frases do dia";
  String _selectedPhrase = "Clique para gerar uma frase";
  var _phrases = [
    'Acredite em si próprio e chegará um dia em que os outros não terão outra escolha senão acreditar com você.',
    "Mudar pode dar medo, mas é uma aventura que pode te levar muito longe",
    "Tenha coragem para se tornar aquilo que sonha.",
    "Há tanta coisa deliciosa para descobrir sobre você. Desafie-se, aventure-se e coloque-se em situações novas.",
    "Minha missão na vida não é apenas sobreviver, mas prosperar.",
    "Jamais se esqueça: você é o motivo do sorriso de muitas pessoas.",
    "Não tenho medo de aceitar que você não é mais o mesmo.",
    "Os sonhos servem para abrir o caminho e mostrar a direção.",
    "Um dia tudo isto ainda vai parecer pequeno, porque tuas conquistas te farão enorme.",
    "Quando estiver em dúvida sobre o caminho, faça um pequeno primeiro movimento. Aos poucos, os próximos passos começarão a ficar mais visíveis."
  ];
  var _random;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text( _title ),
        backgroundColor: Colors.green,
      ),
      body: Container(
            width: double.infinity,
            margin: EdgeInsets.all(12),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
                "images/logo.png",
            ),
            Text(
              _selectedPhrase,
              textAlign: TextAlign.center,
              style:TextStyle(
                fontSize: 20,
                color: Colors.grey,
                wordSpacing: 2,
              ) ,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
              onPressed: (){
                setState(() {
                  _random = Random().nextInt(_phrases.length);
                  _selectedPhrase = _phrases[_random];
                });
              },
              child: Text(
                  "Nova Frase",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight:FontWeight.bold,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
