import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  TextEditingController _controllerAlcool = TextEditingController();
  TextEditingController _controllerGasolina = TextEditingController();
  String _textoResultado = "2";

  void _calcular(){

    double? precoAlcool = double.tryParse( _controllerAlcool.text );
    double? precoGasolina = double.tryParse( _controllerGasolina.text);

    if( precoAlcool == null || precoGasolina == null){
      setState((){
        _textoResultado = "Número invalido, digite números maiores que 0 e utilizando (.)";
      });
    }else{
      if(precoAlcool/precoGasolina >= 0.7){
        _textoResultado = "É melhor abastecer com gasolina";
      }else{
        _textoResultado = "É melhor abastecer com álcool";
      }

      setState((){
        _textoResultado;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Álcool ou Gasolina"),

      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Image.asset(
                  'images/logo.png',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Saiba qual a melhor opção para o abastecimento do seu carro",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:25),
                child: TextField(
                  // text, number, emailAddress, datetime
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Preço Álcool, ex 1.59"
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                  ),
                  onSubmitted: (String text){
                    print("valor digitado onsub: " + text);
                  },
                  controller: _controllerAlcool,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: TextField(
                  // text, number, emailAddress, datetime
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Preço Gasolina, ex 3.15"
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                  ),
                  onSubmitted: (String text){
                    print("valor digitado onsub: " + text);
                  },
                  controller: _controllerGasolina,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    onPressed: _calcular,
                    child: Text(
                      "Calcular",
                        style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  _textoResultado,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        ),
      );
    }
  }

    

