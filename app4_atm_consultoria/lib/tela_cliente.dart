import 'package:flutter/material.dart';

class tela_cliente extends StatefulWidget {
  const tela_cliente({Key? key}) : super(key: key);

  @override
  State<tela_cliente> createState() => _tela_clienteState();
}

class _tela_clienteState extends State<tela_cliente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
              "Clientes"
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
                          "images/detalhe_cliente.png"
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Clientes",
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
                    child: Image.asset(
                        "images/cliente1.png"
                    ),
                  ),
                  Text(
                      "Empresa de Software"
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:16),
                    child: Image.asset(
                        "images/cliente2.png"
                    ),
                  ),
                  Text(
                      "Empresa de Auditoria"
                  ),


                ],
              ),
            )
        )
    );
  }
}
