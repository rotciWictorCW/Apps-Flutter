import 'package:app11_whatsapp/Screens/ChatsTab.dart';
import 'package:app11_whatsapp/Screens/ContactsTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  List<String> menuItens = [
    "Configurações", "Deslogar"
  ];

  String _userEmail= "";

  Future _getUserData() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? loggedUser = auth.currentUser;

    setState(() {
      _userEmail = loggedUser!.email!;
    });

  }

  @override
  void initState() {
    super.initState();

    _getUserData();

    _tabController = TabController(
        length: 2,
        vsync: this
    );

  }

  _selectedMenuItem(String selectedItem){

    switch( selectedItem ){
      case "Configurações":
        Navigator.pushNamed(context, "/settings");
        break;
      case "Deslogar":
        _logout();
        break;

    }
    //print("Item escolhido: " + selectedItem );
  }

  _logout() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()
        )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff075E54),
        title: Text("ZAP"),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: "Conversas",),
            Tab(text: "Contatos",)
          ],
        ),
        actions: [
          PopupMenuButton<String>(
              onSelected: _selectedMenuItem,
              itemBuilder: (context){
              return menuItens.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ChatsTab(),
          ContactsTab()
        ],
      ),
    );
  }
}