import 'package:app7_youtube/telas/Biblioteca.dart';
import 'package:app7_youtube/telas/Emalta.dart';
import 'package:app7_youtube/telas/Inicio.dart';
import 'package:app7_youtube/telas/Inscricao.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

    int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    List telas = [
      Inicio(),
      Emalta(),
      Inscricao(),
      Biblioteca()
    ];
    
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey,
            opacity: 0.8
          ),
          backgroundColor: Colors.white,
          title: Image.asset(
              "images/youtube.png",
              width: 95,
              height: 20,
          ),
          actions: [
            IconButton(
                onPressed: (){
                  print("acao: videocam");
                },
                icon: Icon(Icons.videocam)
            ),
            IconButton(
                onPressed: (){
                  print("acao: search");
                },
                icon: Icon(Icons.search)
            ),
            IconButton(
                onPressed: (){
                  print("acao: account circle");
                },
                icon: Icon(Icons.account_circle)
            )
          ],
        ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: telas[_currentIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        type:BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
              label:"Ínicio",
              icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
              label:"Em alta",
              icon: Icon(Icons.whatshot)
          ),
          BottomNavigationBarItem(
              label:"Inscrições",
              icon: Icon(Icons.subscriptions)
          ),
          BottomNavigationBarItem(
              label:"Biblioteca",
              icon: Icon(Icons.folder)
          )
        ],
      ),
    );
  }
}
