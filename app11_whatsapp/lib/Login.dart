import 'package:app11_whatsapp/Register.dart';
import 'package:app11_whatsapp/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = "";

  _validateFields(){

    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if( email.isNotEmpty && email.contains("@") ){

      if( password.isNotEmpty ){

        setState(() {
          _errorMessage = "";
        });

        nUser user = nUser();
        user.email = email;
        user.password = password;

        _loginUser( user );


      }else{
        setState(() {
          _errorMessage = "Preencha a senha!";
        });
      }

    }else{
      setState(() {
        _errorMessage = "Preencha o E-mail utilizando @";
      });
    }

  }

  _loginUser( nUser user ){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password
    ).then((firebaseUser){

      Navigator.pushReplacementNamed(context, "/home");

    }).catchError((error){

      print("erro: " + error.toString());

      setState(() {
        _errorMessage = "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
      });

    });

  }
  Future _verifyLoggedUser() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();

    User? loggedUser = auth.currentUser;

    if( loggedUser != null ){
      Navigator.pushReplacementNamed(context, "/home");
    }

  }

  @override
  void initState() {
    _verifyLoggedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff075E54)),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: const Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.green,
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: () {
                        _validateFields();
                      }),
                ),
                Center(
                  child: GestureDetector(
                    child: const Text(
                        "Não tem conta? cadastre-se!",
                        style: TextStyle(
                            color: Colors.white
                        )
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()
                          )
                      );
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


