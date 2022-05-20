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

  var _titulo = "Frases do dia";
  var _texto = "iuGAUGSDIUGDIGDAUIGAUGDIAdUSihsidhodhwiohdsohdohdoshhdohsdhoidhsodygdifugudgifgiufgigfidsgfsigifg";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text( _titulo ),
        backgroundColor: Colors.green,
      ),
      body: Container(
            margin: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
                "images/logo.png",
            ),
            Text(
              "Nome: $_texto",
              textAlign: TextAlign.justify,
              style:TextStyle(
                fontSize: 20,
                color: Colors.grey,
                wordSpacing: 2,

              ) ,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: (){
                setState(() {

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
