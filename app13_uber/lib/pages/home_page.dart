import 'dart:convert';
import 'package:app13_uber/model/nUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = "";
  bool _loading = false;

  void _validateFields() {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length >= 6) {
        nUser user = nUser();
        user.email = email;
        user.password = password;

        _userlogin(user);
      } else {
        setState(() {
          _errorMessage = "Preencha a senha! digite mais de 6 caracteres";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Preencha o E-mail válido";
      });
    }
  }

  void _userlogin(nUser user) {
    setState(() {
      _loading = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      _panelRedirectByUserType(auth.currentUser!.uid);
    }).catchError((error) {
      _errorMessage =
          "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
    });
  }

  Future<void> _panelRedirectByUserType(String userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await db.collection("users").doc(userId).get();

    var response = jsonEncode(snapshot.data());
    Map<String, dynamic>? data = jsonDecode(response);
    String? userType = data?["userType"];

    setState(() {
      _loading = false;
    });

    switch (userType) {
      case "driver":
        Navigator.pushReplacementNamed(context, "/driver-panel");
        break;
      case "passenger":
        Navigator.pushReplacementNamed(context, "/passenger-panel");
        break;
    }
  }

  Future<void> _verifyUserIsLogged() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    var loggedUser = auth.currentUser;

    if (loggedUser != null) {
      String userId = loggedUser.uid;
      _panelRedirectByUserType(userId);
    }
  }

  @override
  void initState() {
    super.initState();

    _verifyUserIsLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/fundo.png"),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                TextField(
                  controller: _controllerEmail,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "e-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: const Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: const Color(0xff1ebbd8),
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: () {
                        _validateFields();
                      }),
                ),
                Center(
                  child: GestureDetector(
                    child: const Text(
                      "Não tem conta? Cadastre-se!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/register");
                    },
                  ),
                ),
                _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
