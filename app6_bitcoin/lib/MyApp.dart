import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _preco = "0";

  void _recuperarPreco() async {
    String url = "https://economia.awesomeapi.com.br/last/BTC-BRL";
    http.Response response = await http.get(Uri.parse(url));

    Map<String, dynamic> retorno = jsonDecode(response.body);
    setState(() => {
    _preco =(retorno["BTCBRL"]["bid"])
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(25),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
                "images/bitcoin.png"
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child:Text(
                    "R\$ " + _preco ,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                ) ,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 45,
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                  ),
                  onPressed: _recuperarPreco,
                  child: Text(
                    "Atualizar",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
