import 'package:flutter/material.dart';

class tela_servicos extends StatefulWidget {
  const tela_servicos({Key? key}) : super(key: key);

  @override
  State<tela_servicos> createState() => _tela_servicosState();
}

class _tela_servicosState extends State<tela_servicos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
              "Serviços"
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
                          "images/detalhe_servico.png"
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Sobre os Serviços",
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
                      "Consultoria"
                    ),
                  ),
                   Padding(
                     padding: EdgeInsets.only(top:16),
                     child: Text(
                      "Cálculo de preços"
                     ),
                   ),
                     Padding(
                       padding: EdgeInsets.only(top:16),
                       child: Text(
                           "Acompanhamento de projetos"
                       ),
                       ),

                ],
              ),
            )
        )
    );
  }
}
