import 'package:flutter/material.dart';

class EntradaCheckbox extends StatefulWidget {
  const EntradaCheckbox({Key? key}) : super(key: key);

  @override
  State<EntradaCheckbox> createState() => _EntradaCheckboxState();
}

class _EntradaCheckboxState extends State<EntradaCheckbox> {

  bool _comidaBrasileira = false;
  bool _comidaMexicana = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada Checkbox")
      ),
      body: Container(
        child: Column(
          children: [
            CheckboxListTile(
                title: Text("Comida Brasileira"),
                subtitle: Text("A melhor comida do mundo!!"),
                activeColor: Colors.red,
                //selected: true,
                //secondary: Icon(Icons.add_shopping_cart),
                value: _comidaBrasileira,
                onChanged: (bool? valor){
                  setState((){
                    _comidaBrasileira = valor!;
                  });
                },
              ),
            CheckboxListTile(
              title: Text("Comida Mexicana"),
              subtitle: Text("A melhor comida do mundo!!"),
              activeColor: Colors.red,
              //selected: true,
              //secondary: Icon(Icons.add_shopping_cart),
              value: _comidaMexicana,
              onChanged: (bool? valor){
                setState((){
                  _comidaMexicana = valor!;
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.lightBlueAccent,
              ),
              onPressed: (){
                print("Comida Brasileira: " + _comidaBrasileira.toString());
                print("Comida Mexicana: " + _comidaMexicana.toString());
              },
              child: Text(
                "Salvar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            /*Text(
                "Comida Brasileira"
            ),
            Checkbox(
                value: _estaSelcionado,
                onChanged: (bool? valor){
                  setState((){
                    _estaSelcionado = valor!;
                  });
                },
            ),*/
          ],
        ),
      ),
    );
  }
}
