import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final TextEditingController _controllerName = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _loggedUserId;
  bool _uploadingImage = false;
  String? _recoveredUrlImage;

  Future _getImage(String imageOrigin) async {
    XFile? selectedImage;
    switch (imageOrigin) {
      case "camera" :
        selectedImage = await _picker.pickImage(source: ImageSource.camera);
        break;
      case "gallery" :
        selectedImage = await _picker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _image = File(selectedImage!.path);
      if (_image != null) {
        _uploadingImage = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootFolder = storage.ref();
    Reference file = rootFolder
        .child('profile')
        .child("$_loggedUserId.jpg");

    UploadTask task = file.putFile(_image!);

    task.snapshotEvents.listen((TaskSnapshot taskSnapshot) {

      if(taskSnapshot.state == TaskState.running){
        setState(() {
          _uploadingImage = true;
        });
      }else if (taskSnapshot.state == TaskState.success) {
        _retrieveUrl(taskSnapshot);

      }

    });

    final snapshot = await task.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      _recoveredUrlImage = urlDownload;
    });

  }

  Future _retrieveUrl(TaskSnapshot taskSnapshot) async {
    var url = await taskSnapshot.ref.getDownloadURL();
    _updateImageUrlFirestore( url );

    setState(() {
      _recoveredUrlImage= url;
    });
  }

  _updateImageUrlFirestore(String url) async {

    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dataUpdate = {
      'imageUrl': url
    };

    db.collection('users')
        .doc(_loggedUserId)
        .update(dataUpdate);
  }

  _updateNameFirestore() async {
    await Firebase.initializeApp();

    String name = _controllerName.text;
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dataUpdate = {
      'name': name
    };

    db.collection('users')
        .doc(_loggedUserId)
        .update(dataUpdate);
  }

  _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = auth.currentUser!;
    _loggedUserId = loggedUser.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection('users')
        .doc(_loggedUserId)
        .get();

    var data = jsonEncode(snapshot.data());
    Map<String, dynamic>? valueMap = jsonDecode(data);
    _controllerName.text = valueMap!['name'];

    if ( valueMap['imageUrl'] != null ) {
      setState(() {
        _recoveredUrlImage = valueMap['imageUrl'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
        backgroundColor: const Color(0xff075E54),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Loading
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey,
                backgroundImage:
                    _recoveredUrlImage != null
                      ? NetworkImage(_recoveredUrlImage!)
                      : null
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        _getImage("camera");
                      },
                      child: const Text("Câmera")
                  ),
                  TextButton(
                      onPressed: () {
                        _getImage("gallery");
                      },
                      child: const Text("Galeria")
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _controllerName,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 10),
                child: RaisedButton(
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _updateNameFirestore();
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}