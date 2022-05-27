import 'package:flutter/material.dart';

class EntradaRadiobutton extends StatefulWidget {
  const EntradaRadiobutton({Key? key}) : super(key: key);

  @override
  State<EntradaRadiobutton> createState() => _EntradaRadiobuttonState();
}

class _EntradaRadiobuttonState extends State<EntradaRadiobutton> {

  String _escolhaUsuario = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Entrada Checkbox")
      ),
      body: Container(
        child: Column(
          children: [
            RadioListTile(
                title: Text("Masculino"),
                value: "m",
                groupValue: _escolhaUsuario,
                onChanged: (String? escolha) {
                  setState(() {
                    _escolhaUsuario = escolha!;
                  });
                }),
            RadioListTile(
                title: Text("Feminino"),
                value: "f",
                groupValue: _escolhaUsuario,
                onChanged: (String? escolha) {
                  setState(() {
                    _escolhaUsuario = escolha!;
                  });
                }),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.lightBlueAccent,
        ),
        onPressed: (){
          print("Resultado: " + _escolhaUsuario.toString());
        },
        child: Text(
          "Salvar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
            /*Text("Masculino"),
            Radio(
                value: "m",
                groupValue: _escolhaUsuario,
                onChanged: (String? escolha) {
                  setState(() {
                    _escolhaUsuario = escolha!;
                  });
                  print("resultado: " + escolha!);
                }),
            Text("Feminino"),
            Radio(
              value: "f",
              groupValue: _escolhaUsuario,
              onChanged: (String? escolha) {
                setState(() {
                  _escolhaUsuario = escolha!;
                });
                print("resultado: " + escolha!);
              }),*/
          ],
        ),
      ),
    );
  }
}
