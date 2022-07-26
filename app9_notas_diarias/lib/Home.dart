import 'package:app9_notas_diarias/helper/DatabaseHelper.dart';
import 'package:app9_notas_diarias/model/Note.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  _showRegisterScreen(){
    
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Adicionar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite título..."
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a Descrição"
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")
              ),
              TextButton(
                onPressed: () {
                  _saveNote;
                  Navigator.pop(context);
              },
                  child: Text("Salvar")

          ),
            ],
          );
        }
    );
    
  }

  _saveNote() async{

    String title = _titleController.text;
    String description = _descriptionController.text;
    String date = DateTime.now().toString();

    Note note = Note(title, description, date);
    int result = await _db.saveNote(note);
    print("salvar ${ result.toString() }");

    _titleController.text = "";
    _descriptionController.text = "";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anotações"),
        backgroundColor: Colors.green,
      ),
      body:Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: (){
          _showRegisterScreen();
        },
      ),
    );
  }
}
