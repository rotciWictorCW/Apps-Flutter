import 'package:flutter/material.dart';

class EntradaSwitch extends StatefulWidget {
  const EntradaSwitch({Key? key}) : super(key: key);

  @override
  State<EntradaSwitch> createState() => _EntradaSwitchState();
}

class _EntradaSwitchState extends State<EntradaSwitch> {

  bool _escolhaUsuario = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Entrada Slider")
      ),
      body: Container(
        child: Column(
          children: [
            Switch(
                value: false,
                onChanged: (bool? escolha) {
                  setState(() {
                    _escolhaUsuario = escolha!;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
