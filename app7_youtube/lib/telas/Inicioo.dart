import 'package:app7_youtube/model/Video.dart';
import 'package:app7_youtube/telas/API.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Inicio extends StatefulWidget {
  String pesquisa = "";
  Inicio(this.pesquisa, {Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    var url ='https://www.youtube.com/watch?v=yEGQuMjbBbg';

    YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url)!,
        flags: const YoutubePlayerFlags(
          mute: false, // is video sound playing?
          loop: false, // is same video repeated?
          autoPlay: false,
        ),
    );
  }

  _listVideos(String pesquisa){
    Api api = Api();
    return api.search( pesquisa );
}
  @override
  Widget build(BuildContext context) {


    return FutureBuilder<List<Video>>(
      future: _listVideos( widget.pesquisa),
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

                    return GestureDetector(
                        onTap: (){
                    },
                        child: Column(
                        children: [

                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit:BoxFit.cover,
                                image: NetworkImage(video.imagem)
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text( video.titulo),
                          subtitle: Text( video.descricao),
                        )
                      ],
                    )
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 2,
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
