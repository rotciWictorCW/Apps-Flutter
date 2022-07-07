import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app11_whatsapp/model/Chat.dart';
import 'package:app11_whatsapp/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({Key? key}) : super(key: key);

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {

  String? _loggedUserId;
  String? _loggedUserEmail;

  Future<List<nUser>> _getContacts() async {

    Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot =
    await db.collection("users").getDocuments();

    List<nUser> usersList = List();
    for (DocumentSnapshot item in querySnapshot.documents) {

      var data = item.data;
      if( dados["email"] == _loggedUserEmail ) continue;

      nUser user = nUser();
      user.email = data["email"];
      user.name = data["nome"];
      user. = data["urlImagem"];

      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    _emailUsuarioLogado = usuarioLogado.email;

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
---------------------------------------------
  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando contatos"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, indice) {
                  List<Usuario> listaItens = snapshot.data;
                  Usuario usuario = listaItens[indice];

                  return ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: usuario.urlImagem != null
                            ? NetworkImage(usuario.urlImagem)
                            : null),
                    title: Text(
                      usuario.nome,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                });
            break;
        }
      },
    );
  }
}