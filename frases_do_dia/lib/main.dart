import 'package:flutter/material.dart';

void onPressed(){
  print("Botão pressionado!");
}

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
  var _texto = "Victor Campos";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text( _titulo ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
                onPressed: (){
                  setState(() {
                    _texto = "Curso Flutter";
                  });


                },
                color: Colors.blueAccent,
                child: Text("Clique aqui"),

            ),
            Text("Nome: $_texto")
          ],
      ),
      ),
    );
  }
}


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var _titulo = "Frases do dia";

    return Scaffold(
      appBar: AppBar(
        title: Text( _titulo ),
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
              children: const <Widget>[
                Text('Conteúdo princioal'),
                Text('Outro Conteúdo'),

              ],
            ),
          )
      ),
    );
  }
}
