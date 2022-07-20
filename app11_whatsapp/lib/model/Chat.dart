import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {

  String? _userId;
  String? _receiverId;
  String? _name;
  String? _message;
  String? _photoPath;
  String? _messageType;


  Chat();

  save() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('chats')
        .doc( userId )
        .collection( 'last_chat' )
        .doc( receiverId )
        .set(toMap());
  }


  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'idSender' : _userId,
      'idReceipt' : _receiverId,
      'name' : _name,
      'message' : _message,
      'pathPhoto' : _photoPath,
      'messageType' : _messageType
    };
    return map;
  }


  String get userId => _userId!;

  set userId(String value) {
    _userId = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  String get message => _message!;

  String get photoPath => _photoPath!;

  set photoPath(String value) {
    _photoPath = value;
  }

  set message(String value) {
    _message = value;
  }

  String get receiverId => _receiverId!;

  set receiverId(String value) {
    _receiverId = value;
  }

  String get messageType => _messageType!;

  set messageType(String value) {
    _messageType = value;
  }
}