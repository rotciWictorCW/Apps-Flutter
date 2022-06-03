import 'package:app7_youtube/model/Video.dart';
import 'package:app7_youtube/telas/API.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  _listVideos(){

    Future <List<Video>> videos;
    
    Api api = Api();
    return api.search("");
    
}

  @override
  Widget build(BuildContext context) {


    return FutureBuilder<List<Video>>(
      future: _listVideos(),
      builder: (context, snapshot){
        if( snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasData){

              return ListView.separated(
                  itemBuilder: (context, index){

                    List<Video>? videos = snapshot.data;
                    Video video = videos![index];
                    print(video.imagem);


                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                                image: NetworkImage(
                                  ("https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg"),
                                ),
                            ),
                          ),
                        ),
                      ],
                    );

                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 200,
                    color:  Colors.grey,
                  ),
                  itemCount: snapshot.data!.length
              );

            }
        }
        return Container();
      },
    );
  }
}
