import 'package:app9_notas_diarias/Home.dart';
import 'package:app9_notas_diarias/helper/DatabaseHelper.dart';
import 'package:app9_notas_diarias/model/Note.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = DatabaseConnect();

  await db.insertNote(Note(
    id: 1,
    title: 'this is the sample note',
    description: 'this is the sample note',
    date: DateTime.now().toString(),
  ));
  print(await db.getNote);

  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}
