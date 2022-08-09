import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/firebase_user.dart';
import '../utils/status_requisition.dart';

class DriverPanel extends StatefulWidget {
  const DriverPanel({Key? key}) : super(key: key);

  @override
  State<DriverPanel> createState() => _DriverPanelState();
}

class _DriverPanelState extends State<DriverPanel> {
  List<String> menuItens = ["Configurações", "Deslogar"];

  final _controller =
      StreamController<QuerySnapshot<Map<String, dynamic>>>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;

  void _logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  void _itemMenuChoice(String choice) {
    switch (choice) {
      case "Deslogar":
        _logout();
        break;
      case "Configurações":
        break;
    }
  }

  Stream<QuerySnapshot> _addRequisitionListener() {
    final stream = db
        .collection('requisitions')
        .where('status', isEqualTo: StatusRequisition.WAITING)
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });

    return _controller.stream;
  }

  _getActiveDriverRequisition() async {
    User firebaseUser = FirebaseUser.getCurrentUser();

    DocumentSnapshot<Map> documentSnapshot = await db
        .collection('active_requisition_driver')
        .doc(firebaseUser.uid)
        .get();

    var requisitionData = documentSnapshot.data();

    if (requisitionData == null) {
      _addRequisitionListener();
    } else {
      String requisitionId = requisitionData['id_requisition'];
      Navigator.pushReplacementNamed(context, '/ride',
          arguments: requisitionId);
    }
  }

  @override
  void initState() {
    super.initState();

    _addRequisitionListener();

    _getActiveDriverRequisition();

  }

  @override
  Widget build(BuildContext context) {
    var loadingMessage = Center(
      child: Column(
        children: const [
          Text('Carregando requisições'),
          CircularProgressIndicator()
        ],
      ),
    );

    var messageHasNoData = Center(
      child: Column(
        children: const [
          Text(
            'Você não tem nenhuma requisição :( ',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel motorista'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _itemMenuChoice,
            itemBuilder: (context) {

              return menuItens.map((String item) {

                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );

              }).toList();

            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch ( snapshot.connectionState ) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return loadingMessage;
            case ConnectionState.active:
            case ConnectionState.done:

              if (snapshot.hasError) {
                return const Text('Erro ao carregar os dados!');
              } else {

                QuerySnapshot<Map<String,dynamic>>? querySnapshot = snapshot.data;

                if ( querySnapshot?.docs.length == 0) {
                  return messageHasNoData;
                } else {

                  return ListView.separated(
                    itemCount: querySnapshot!.docs.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context, index) {

                      List<DocumentSnapshot> requisitions = querySnapshot.docs.toList();
                      DocumentSnapshot item = requisitions[index];

                      String requisitionId = item['id'];
                      String passengerName = item['passenger']['name'];
                      String street = item['destination']['street'];
                      String number = item['destination']['number'];

                      return ListTile(
                        title: Text(passengerName),
                        subtitle: Text('destino: $street, $number'),
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              '/ride',
                              arguments: requisitionId
                          );
                        },
                      );

                    },
                  );

                }
              }
          }
          return const Center(
            child: Text('Algo de errado ocorreu! Por favor carregue novamente!'),
          );

        },
      ),
    );
  }
}
