import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados"),
      ),
      body: Container(
        width: double.infinity,

          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(32),
                  child: TextField(
                    // text, number, emailAddress, datetime
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Digite um valor"
                    ),
                    //enabled: false,
                    maxLength: 10,
                    //maxLengthEnforcement: , não parece funcionar o max legth ja trava
                    /*style: TextStyle(
                      fontSize: 32,
                      color: Colors.green,
                    ),*/
                    //obscureText: true,
                    /*onChanged: (String e){
                      print("valor digitado: " + text);
                    },*/
                    onSubmitted: (String text){
                      print("valor digitado onsub: " + text);
                    },
                    controller: _textEditingController,
                  ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                onPressed: (){
                  print("valor digitado: " + _textEditingController.text);
                },
                child: Text(
                  "Salvar"
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

    

