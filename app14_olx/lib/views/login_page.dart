import 'package:app14_olx/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app14_olx/views/customized_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail =
      TextEditingController();
  TextEditingController _controllerPassword =
      TextEditingController();

  bool _register = false;
  String _errorMessage = "";
  String _textButton = "Entrar";

  _registerUser(user_n user) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
            email: user.email, 
            password: user.password
            ).then((firebaseUser) {
      //redireciona para tela principal
    });
  }

  _loginUser(user_n user) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((firebaseUser) {
      //redireciona para tela principal
    });
  }

  _validateFields() {
    
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length >= 6) {
        //config user
        user_n user = user_n();
        user.email = email;
        user.password = password;

        //register or login
        if (_register) {
          //register
          _registerUser(user);
        } else {
          //login
          _loginUser(user);
        }
      } else {
        setState(() {
          _errorMessage = "Preencha a password! digite mais de 6 caracteres";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Preencha o E-mail válido";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                CustomizedInput(
                  controller: _controllerEmail,
                  hint: "E-mail",
                  autofocus: true,
                  type: TextInputType.emailAddress,
                ),
                CustomizedInput(
                    controller: _controllerPassword, 
                    hint: "Senha", 
                    obscure: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Logar"),
                    Switch(
                      value: _register,
                      onChanged: (bool valor) {
                        setState(() {
                          _register = valor;
                          _textButton = "Entrar";
                          if (_register) {
                            _textButton = "Cadastrar";
                          }
                        });
                      },
                    ),
                    const Text("Cadastrar"),
                  ],
                ),
                RaisedButton(
                  child: Text(
                    _textButton,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xff9c27b0),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  onPressed: () {
                    _validateFields();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
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
