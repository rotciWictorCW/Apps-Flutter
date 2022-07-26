import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app12_minhas_viagens/Screens/map.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  _openMap(String idTrip) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MapScreen(
                  tripID: idTrip,
                )));
  }

  _deleteTrip(String idTrip) {
    _db.collection("trips").doc(idTrip).delete();
  }

  _addLocal() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MapScreen(
              tripID: null,
            )
        ));
  }

  _addTripListener() async {
    final stream = _db.collection("trips").snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  @override
  void initState() {
    super.initState();

    _addTripListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas viagens"),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff0066cc),
          onPressed: () {
            _addLocal();
          },
          child: const Icon(Icons.add)),
      body: StreamBuilder<QuerySnapshot>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
                List<DocumentSnapshot> trips =
                    querySnapshot.docs.toList();

                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          itemCount: trips.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot item = trips[index];
                            String title = item["title"];

                            return GestureDetector(
                              onTap: () {
                                _openMap(item.id);
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(title),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _deleteTrip(item.id);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                );

                break;
            }
          }),
    );
  }
}
