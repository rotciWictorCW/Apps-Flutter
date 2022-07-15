import 'package:app11_whatsapp/model/User.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'model/Message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chats extends StatefulWidget {

  final nUser contact;

  const Chats({Key? key, required this.contact}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  late String _loggedUserId;
  late String _receiverUserId;
  List<String> messagesList = [
    "Olá meu amigo, tudo bem?",
    "Tudo ótimo!!! e contigo?",
    "Estou muito bem!! queria ver uma coisa contigo, você vai na corrida de sábado?",
    "Não sei ainda :(",
    "Pq se você fosse, queria ver se posso ir com você...",
    "Posso te confirma no sábado? vou ver isso",
    "Opa! tranquilo",
    "Excelente!!",
    "Estou animado para essa corrida, não vejo a hora de chegar! ;) ",
    "Vai estar bem legal!! muita gente",
    "vai sim!",
    "Lembra do carro que tinha te falado",
    "Que legal!!"
  ];

  TextEditingController _controllerChat = TextEditingController();

  _sendMessage(){

    String messageText = _controllerChat.text;
    if( messageText.isNotEmpty ){

      Message message = Message();
      message.UserId = _loggedUserId;
      message.message  = messageText;
      message.imageUrl = "";
      message.type = "text";

      _saveMessage(_loggedUserId, _receiverUserId, message);

    }

  }

  _saveMessage(String idUser, String idReceiver, Message msg) async {

    Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("messages").doc( idUser ).collection( idReceiver ).add( msg.toMap() );

    _controllerChat.clear();

  }

  _sendPhoto(){

  }

  _getUserData() async {
    Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser!;
    _loggedUserId = loggedUser.uid;
    _receiverUserId = widget.contact.idUser;
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {

    var chatBox = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerChat,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite uma mensagem...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                    ),
                    prefixIcon: IconButton(
                        icon: Icon(
                            Icons.camera_alt,
                            color: Color(0xff075E54),
                        ),
                        onPressed: _sendPhoto
                    )
                ),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(Icons.send, color: Colors.white,),
            mini: true,
            onPressed: _sendMessage,
          )
        ],
      ),
    );

    var listView = Expanded(
      child: ListView.builder(
          itemCount: messagesList.length,
          itemBuilder: (context, index){

            double containerWidth = MediaQuery.of(context).size.width * 0.8;

            Alignment alignment = Alignment.centerRight;
            Color color = Color(0xffd2ffa5);
            if( index % 2 == 0 ){
              alignment = Alignment.centerLeft;
              color = Colors.white;
            }

            return Align(
              alignment: alignment,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Container(
                  width: containerWidth,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Text(
                    messagesList[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }
      ),
    );


    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: <Widget>[
              CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: widget.contact.imageUrl != null
                      ? NetworkImage(widget.contact.imageUrl)
                      : null),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(widget.contact.name),
              )
            ],
          ),
          backgroundColor: const Color(0xff075E54),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover
            )
        ),
        child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  listView,
                  chatBox,
                  //listview
                  //caixa mensagem
                ],
              ),
            )
        ),
      ),
    );
  }
}
