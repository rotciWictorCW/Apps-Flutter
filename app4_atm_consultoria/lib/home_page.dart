import 'package:flutter/material.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {

  void _abrirEmpresa(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ATM Consultoria"),
        backgroundColor: Colors.green,
      ) ,
      body:Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
                "images/logo.png"
            ),
            Padding(
                padding: EdgeInsets.only(top:32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: _abrirEmpresa,
                      child: Image.asset(
                        "images/menu_empresa.png"
                      ),
                    ),
                    GestureDetector(
                      onTap: _abrirEmpresa,
                      child: Image.asset(
                          "images/menu_servico.png"
                      ),
                    ),
                  ],
                ),
            ),
          Padding(
      padding: EdgeInsets.only(top:32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _abrirEmpresa,
            child: Image.asset(
                "images/menu_cliente.png"
            ),
          ),
          GestureDetector(
            onTap: _abrirEmpresa,
            child: Image.asset(
                "images/menu_contato.png"
            ),
          ),
        ],
      ),
          )
          ],
        ),
      ) ,
    );
  }
}
