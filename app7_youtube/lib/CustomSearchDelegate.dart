import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: (){},
          icon: Icon(Icons.clear)
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return 
      IconButton(
          onPressed: (){
            close(context, "");
          },
          icon: Icon(Icons.arrow_back)
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      List<String> lista = [query ,'Android', 'Android navegação', 'IOS', 'Jogos']
          .where(
              (texto) => texto.toLowerCase().startsWith(query.toLowerCase())
      ).toList();
      return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(lista[index]),
              onTap: () {
                close(context, lista[index]);
              },
            );
          });
    } else {
      return const Center(
        child: Text('Escreve alguma coisa'),
      );
    }
  }
}