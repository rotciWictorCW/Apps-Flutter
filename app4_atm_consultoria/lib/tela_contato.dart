import 'package:flutter/material.dart';

class tela_contato extends StatefulWidget {
  const tela_contato({Key? key}) : super(key: key);

  @override
  State<tela_contato> createState() => _tela_contatoState();
}

class _tela_contatoState extends State<tela_contato> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
              "Contato"
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                          "images/detalhe_contato.png"
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Sobre a Empresa",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:16),
                    child: Text(
                        "atendimento@atmconsultoria.com.br"
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:16),
                    child: Text(
                        "Telefone (21) 8765-4321"
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:16),
                    child: Text(
                        "Celular (21) 98765-4321"
                    ),
                  ),

                ],
              ),
            )
        )
    );
  }
}
