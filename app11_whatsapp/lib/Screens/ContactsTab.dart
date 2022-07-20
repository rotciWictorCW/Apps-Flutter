import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      await db.collection("users").get();

    print("dados: " + querySnapshot.docs.toString());

    List<nUser> usersList = [];
    for (DocumentSnapshot item in querySnapshot.docs) {

      var response = jsonEncode(item.data());
      Map<String, dynamic> data = jsonDecode(response);

      print("datafirebase :" + data.toString());

      if( data["email"] == _loggedUserEmail ) continue;

      nUser user = nUser();
      user.idUser = item.id;
      user.email = data["email"];
      user.name = data["name"];
      user.imageUrl = data["imageUrl"];

      usersList.add(user);
    }

    return usersList;

  }

  _getUserData() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser =  auth.currentUser!;
    _loggedUserId = loggedUser.uid;
    _loggedUserEmail = loggedUser.email;

  }
  @override
  void initState() {
    super.initState();
    _getUserData();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<nUser>>(
      future: _getContacts(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: const <Widget>[
                  Text("Carregando contatos"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
          List<nUser>? itensList = snapshot.data;
            return ListView.builder(
                itemCount: itensList?.length ?? 0,
                itemBuilder: (_, index) {
                  nUser? user = itensList?[index];

                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(
                          context,
                          "/chats",
                        arguments: user
                      );
                    },
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: user?.imageUrl!= null
                            ? NetworkImage(user!.imageUrl)
                            : null),
                    title: Text(
                      user?.name ?? "",
                      style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                });
            break;
        }
      },
    );
  }
}