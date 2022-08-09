import 'package:app13_uber/model/nUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _userType = false;
  String _errorMessage = "";

  _validateFields() {
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (name.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (password.isNotEmpty && password.length >= 6) {
          nUser user = nUser();
          user.name = name;
          user.email = email;
          user.password = password;
          user.userType = user.verifyUserType(_userType);

          _registerUser(user);
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
    } else {
      setState(() {
        _errorMessage = "Preencha o Nome";
      });
    }
  }

  Future<void> _registerUser(nUser user) async {
    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;

      final firebaseUser = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      var uid = firebaseUser.user!.uid;

      try {
        db.collection("users")
        .doc(uid)
        .set(user.toMap());
      } catch (e) {
        print("rrr " + e.toString()); 
      //flutter ( 7097): yyy Null check operator used on a null value
      }

      //redireciona para o painel, de acordo com o tipoUsuario
      print("redirecting with user's type ${user.userType}");
      switch (user.userType) {
        case "driver":
          Navigator.pushNamedAndRemoveUntil(
              context, "/driver-panel", (_) => false);
          break;
        case "passenger":
          Navigator.pushNamedAndRemoveUntil(
              context, "/passenger-panel", (_) => false);
          break;
      }
    } catch (e) {
      setState(() {
        print("yyy $e");
        _errorMessage =
            'Erro ao cadastrar, verifique os campos e tente novamente';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0f3b49),
        title: const Text(
          "Cadastro",
          style: TextStyle(color: Colors.white),
        ),
      ),
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
                TextField(
                  controller: _controllerName,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome completo",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerEmail,
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
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      const Text(
                        "Passageiro",
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                          value: _userType,
                          onChanged: (bool valor) {
                            setState(() {
                              _userType = valor;
                            });
                          }),
                      const Text(
                        "Motorista",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: const Color(0xff1ebbd8),
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: () {
                        _validateFields();
                      }),
                ),
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
