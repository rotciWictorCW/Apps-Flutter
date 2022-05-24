import 'dart:math';

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State <Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  
  var _imageApp = AssetImage("images/padrao.png");
  var _message = "Escolha uma opção abaixo:";
  var winMessage = "Você ganhou!!!";
  var lossMessage = "Você perdeu :((";
  var drawMessage = "Empate :|";
  void _selectedOption(String userChoice){
    var choices = ["stone","paper","scissor"];
    var random = Random().nextInt(3);
    var appChoice = choices[random];


  //Mostra imagem da escolha do App
    switch( appChoice ) {
      case "stone" :
        setState(() {
          this._imageApp = AssetImage("images/pedra.png");
        });
        break;
      case "paper" :
        setState(() {
          this._imageApp = AssetImage("images/papel.png");
        });
        break;
      case "scissor" :
        setState(() {
          this._imageApp = AssetImage("images/tesoura.png");
        });
        break;
    }
    // retorna quem ganhou

    if((appChoice == "stone" && userChoice == "paper")
    || (appChoice == "paper" && userChoice == "scissor")
    || (appChoice == "scissor" && userChoice == "stone")
    ){
      setState(() => {
        this._message = winMessage
      }
      );
    }else if((appChoice == "stone" && userChoice == "scissor")
        || (appChoice == "paper" && userChoice == "stone")
        || (appChoice == "scissor" && userChoice == "paper")
    ){
      setState(() => {
        this._message = lossMessage
        }
      );
    }else{
      setState(() => {
        this._message = drawMessage
        }
      );
    }




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( "Jokenpo"),
      ),
      body:Container(
      width: double.infinity,
      margin: EdgeInsets.all(12),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
                "Escolha do App:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
            )
          ),
          Image(
              image: this._imageApp
          ),
          Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                _message,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment:CrossAxisAlignment.center ,
            children: [
              GestureDetector(
                onTap: () => _selectedOption("paper"),
                child: Image.asset(
                  'images/papel.png',
                  height: 100,
                ),
              ),

              GestureDetector(
                onTap: () => _selectedOption("stone"),
                child: Image.asset(
                  'images/pedra.png',
                  height: 100,
                ),
              ),

              GestureDetector(
                onTap: () => _selectedOption("scissor"),
                child: Image.asset(
                  'images/tesoura.png',
                  height: 100,
                ),
              ),
            ],
          )
        ],
      ),
    )
    );
    
  }
}
