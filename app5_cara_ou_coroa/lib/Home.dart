import 'dart:math';

import 'package:app5_cara_ou_coroa/Resultado.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _exibirResultado(){

    var itens = ["cara", "coroa"];
    var numero = Random().nextInt(2);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Resultado(itens[numero])
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff61bd86),
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
                "images/logo.png"
            ),
            GestureDetector(
              onTap: _exibirResultado,
              child: Image.asset(
                  "images/jogar.png"
              ),
            ),

          ],
        ),
      ) ,
    );
  }
}
