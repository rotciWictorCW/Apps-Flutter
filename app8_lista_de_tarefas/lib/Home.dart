import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _taskList = [];
  Map<String, dynamic> _lastTaskRemoved = Map();
  TextEditingController _controllerTask = TextEditingController();

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  _saveTask(){

    String inputedText = _controllerTask.text;

    Map<String, dynamic> task = Map();
    task["title"] = inputedText;
    task["done"] = false;

    setState((){
      _taskList.add(task);
    });

    _saveList();
    _controllerTask.text = "";
  }

  _saveList() async {
    var archive = await _getFile();

    String data = jsonEncode(_taskList);
    archive.writeAsStringSync(data);
  }

  _readList() async {
    try {
      final archive = await _getFile();
      return archive.readAsString();
    } catch (e) {
      return "";
    }
  }

  @override
  void initState() {
    super.initState();

    _readList().then((data) {
      setState(() {
        _taskList = json.decode(data);
      });
    });

  }

  Widget createListItem (context, index){
    final item = _taskList[index]["title"];

    return Dismissible(
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        onDismissed: (direction){
          _lastTaskRemoved = _taskList[index];
          _taskList.removeAt(index);
          //_saveList();

          final snackbar = SnackBar(
              backgroundColor: Colors.purple,
              duration: Duration(seconds: 5),
              content: Text(""
                  "Tarefa Removida",
              ),
              action: SnackBarAction(
                label: "Desfazer",
                onPressed: (){

                  setState((){
                    _taskList.insert(index, _lastTaskRemoved);
                  });

                  _saveList();
                },

          ),
          );

          Scaffold.of(context).showSnackBar(snackbar);
        },
        direction: DismissDirection.endToStart,

        background: Container(
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                  Icons.delete,
                  color: Colors.white,
              )
            ],
          ),
        ),
        child: CheckboxListTile(
          title: Text(_taskList[index]["title"]),
          value: _taskList[index]["done"],
          onChanged: (value){
            setState(() {
              _taskList[index]["done"] = value;
            });
            _saveList();
          },
        ),
    );
  }
  @override
  Widget build(BuildContext context) {
    //_saveList();

    print(_taskList.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Adicionar Tarefa"),
                    content: TextField(
                      controller: _controllerTask,
                      decoration:
                      InputDecoration(labelText: "Digite sua tarefa"),
                      onChanged: (text) {},
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancelar")),
                      TextButton(
                          onPressed: () {
                            _saveTask();
                            print(_taskList);
                            Navigator.pop(context);
                          },
                          child: Text("Salvar"))
                    ],
                  );
                });
          }),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _taskList.length,
                  itemBuilder: createListItem
                  )
          )
        ],
      ),
    );
  }
}
