import 'package:app11_whatsapp/model/Chat.dart';
import 'package:flutter/material.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  List<Chat> chatList = [
    Chat(
      "Ana Clara",
      "Olá tudo bem?",
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-93be6.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=cf6cbde4-c5f2-45b6-8002-621f3c0c1bf6"
    ),
    Chat(
        "Pedro Silva",
        "Me manda o nome daquela série que falamos!",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-93be6.appspot.com/o/profile%2Fperfil2.jpg?alt=media&token=01539849-979d-4325-91c8-b576659a4113"
    ),
    Chat(
        "Marcela Almeida",
        "Vamos sair hoje?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-93be6.appspot.com/o/profile%2Fperfil3.jpg?alt=media&token=5d878943-4125-401f-b61d-16c8251896d6"
    ),
    Chat(
        "José Renato",
        "Não vai acreditar no que tenho para te contar...",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-93be6.appspot.com/o/profile%2Fperfil4.jpg?alt=media&token=6c137529-627e-44d8-a344-1f2e4890ce7a"
    ),
    Chat(
        "Jamilton Damasceno",
        "Curso novo!! depois dá uma olhada!!",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-93be6.appspot.com/o/profile%2Fperfil5.jpg?alt=media&token=fc89a72b-1350-42c9-9e8c-6e343f8b37be"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          Chat chat = chatList[index];

          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(chat.photoPath),
            ),
            title: Text(
              chat.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
            subtitle: Text(
                chat.message,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14
                )
            ),
          );
        }
    );
  }
}