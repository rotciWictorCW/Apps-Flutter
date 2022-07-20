import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app11_whatsapp/model/User.dart';


class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String _loggedUserId;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Stream<QuerySnapshot>? _addChatListener() {
    final stream = db
        .collection('chats')
        .doc(_loggedUserId)
        .collection('last_chat')
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  Future<void> _getUserData() async {
    Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser!;
    _loggedUserId = loggedUser.uid;

    _addChatListener();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: const [
                    Text('Carregando mensagens'),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Text('Erro ao carregar os dados!');
              } else {
                QuerySnapshot? querySnapshot = snapshot.data;

                if (querySnapshot?.docs.length == 0) {
                  return const Center(
                    child: Text(
                      'Você nao tem nennuma mensagem ainda!',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: querySnapshot!.docs.length,
                    itemBuilder: (context, index) {
                      List<DocumentSnapshot> conversations =
                      querySnapshot.docs.toList();
                      DocumentSnapshot item = conversations[index];

                      String imageUrl = item['pathPhoto'];
                      String type = item['messageType'];
                      String message = item['message'];
                      String name = item['name'];
                      String idReceiver = item['idReceipt'];

                      nUser user = nUser();
                      user.name = name;
                      user.imageUrl = imageUrl;
                      user.idUser = idReceiver;

                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/chats',
                              arguments: user);
                        },
                        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        leading: CircleAvatar(
                          maxRadius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                          imageUrl != null ? NetworkImage(imageUrl) : null,
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          type == 'text' ? message : 'Imagem...',
                          style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      );
                    });
              }
          }
        });
  }
}