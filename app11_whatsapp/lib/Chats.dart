import 'dart:async';
import 'package:app11_whatsapp/model/User.dart';
import 'package:flutter/material.dart';
import 'model/Chat.dart';
import 'model/Message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Chats extends StatefulWidget {
  final nUser contact;

  const Chats({Key? key, required this.contact}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  bool _uploadingImage = false;
  late String _loggedUserId;
  late String _receiverUserId;


  final TextEditingController _controllerChat = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    String messageText = _controllerChat.text;
    if (messageText.isNotEmpty) {
      Message message = Message();
      message.UserId = _loggedUserId;
      message.message = messageText;
      message.imageUrl = "";
      message.date = Timestamp.now().toString();
      message.type = "text";

      //save for user
      _saveMessage(_loggedUserId, _receiverUserId, message);
      //save for receiver
      _saveMessage(_receiverUserId, _loggedUserId, message);
      //save conversation
      _saveChat(message);
    }
  }

  void _saveChat(Message msg) {
    // save chat for user
    Chat cUser = Chat();
    cUser.receiverId = _loggedUserId;
    cUser.userId = _receiverUserId;
    cUser.message = msg.message;
    cUser.name = widget.contact.name;
    cUser.photoPath = widget.contact.imageUrl;
    cUser.messageType = msg.type;
    cUser.save();

    // save chat for receiver
    Chat cReceiver = Chat();
    cReceiver.receiverId = _receiverUserId;
    cReceiver.userId = _loggedUserId;
    cReceiver.message = msg.message;
    cReceiver.name = widget.contact.name;
    cReceiver.photoPath = widget.contact.imageUrl;
    cReceiver.messageType = msg.type;
    cReceiver.save();
  }

  Future<void> _saveMessage(
      String idUser, String idReceiver, Message msg) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db
        .collection("messages")
        .doc(idUser)
        .collection(idReceiver)
        .add(msg.toMap());

    _controllerChat.clear();
  }

  Future<void> _sendPhoto() async {
    ImagePicker picker = ImagePicker();
    XFile? selectedImage;
    selectedImage = await picker.pickImage(source: ImageSource.gallery);

    File image = File(selectedImage!.path);

    _uploadingImage = true;
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootFolder = storage.ref();
    Reference file = rootFolder
        .child('messages')
        .child(_loggedUserId)
        .child(imageName + ".jpg");

    UploadTask task = file.putFile(image);

    task.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.running) {
        setState(() {
          _uploadingImage = true;
        });
      } else if (taskSnapshot.state == TaskState.success) {
        _retrieveUrl(taskSnapshot);
        setState(() {
          _uploadingImage = false;
        });
      }
    });
  }

  Future _retrieveUrl(TaskSnapshot taskSnapshot) async {
    var url = await taskSnapshot.ref.getDownloadURL();

    Message message = Message();
    message.UserId = _loggedUserId;
    message.message = '';
    message.imageUrl = url;
    message.date = Timestamp.now().toString();
    message.type = 'image';

    _saveMessage(_loggedUserId, _receiverUserId, message);
    _saveMessage(_receiverUserId, _loggedUserId, message);
  }

  Future<void> _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser!;
    _loggedUserId = loggedUser.uid;
    _receiverUserId = widget.contact.idUser;

    _addMessagesListener();
  }

  //Stream _stream() {
  //  FirebaseFirestore db = FirebaseFirestore.instance;

  //  return db
 //       .collection("messages")
  //      .doc(_loggedUserId)
  //      .collection(_receiverUserId)
   //     .snapshots();
 // }

  bool _addMessagesListener() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final stream = db
        .collection("messages")
        .doc(_loggedUserId)
        .collection(_receiverUserId)
        .orderBy("date", descending: false)
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
      Timer(const Duration(seconds: 1),(){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var chatBox = Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerChat,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite uma mensagem...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    prefixIcon: _uploadingImage
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Color(0xff075E54),
                            ),
                            onPressed: _sendPhoto)),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: const Color(0xff075E54),
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: _sendMessage,
          )
        ],
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
              padding: const EdgeInsets.only(left: 8),
              child: Text(widget.contact.name),
            )
          ],
        ),
        backgroundColor: const Color(0xff075E54),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              StreamBuilder(
                  stream: _controller.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Column(
                            children: <Widget>[
                              const Text("Carregando mensagens"),
                              const CircularProgressIndicator()
                            ],
                          ),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        QuerySnapshot? querySnapshot =
                            snapshot.data as QuerySnapshot<Object?>?;

                        if (snapshot.hasError) {
                          return const Expanded(
                            child: Text("Erro ao carregar"),
                          );
                        } else {
                          return Expanded(
                            child: ListView.builder(
                                controller: _scrollController,
                                reverse: false,
                                itemCount: querySnapshot?.docs.length ?? 0,
                                itemBuilder: (context, index) {
                                  List<DocumentSnapshot>? messages =
                                      querySnapshot?.docs.toList();
                                  Map<String, dynamic>? item = messages?[index]
                                      .data() as Map<String, dynamic>;
                                  double containerWidth =
                                      MediaQuery.of(context).size.width * 0.8;

                                  Alignment alignment = Alignment.centerRight;
                                  Color color = const Color(0xffd2ffa5);
                                  if (item != null &&
                                      _loggedUserId != item["userId"]) {
                                    alignment = Alignment.centerLeft;
                                    color = Colors.white;
                                  }

                                  return Align(
                                    alignment: alignment,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Container(
                                        width: containerWidth,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(8))),
                                        child: item['type'] == 'text'
                                            ? Text(
                                                item['message'],
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              )
                                            : Image.network(item['imageUrl']),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }


                    }
                  }),
              chatBox,
              //listview
              //caixa mensagem
            ],
          ),
        )),
      ),
    );
  }
}
