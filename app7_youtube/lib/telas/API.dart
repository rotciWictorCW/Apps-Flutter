import 'package:app7_youtube/model/Video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const YOUTUBE_API = "AIzaSyDjsNGdCvz74KFsMzxcpbEbQYneiV6sC7w";
const CHANNEL_ID = "UCVHFbqXqoYvEWM1Ddxl0QDg";
const BASE_URL = "https://www.googleapis.com/youtube/v3/";

class Api {

  Future<List<Video>> search(String pesquisa) async {

    http.Response response = await http.get(Uri.parse(
      BASE_URL + "search"
          "?part=snippet"
          "&type=video"
          "&maxResults=20"
          "&order=date"
          "&key=$YOUTUBE_API"
          "&channelId=$CHANNEL_ID"
          "&q=$pesquisa"
    ));
    
    if( response.statusCode == 200 ) {

      Map<String, dynamic> dadosJson = json.decode(response.body);

      List<Video> videos = dadosJson["items"].map<Video>(
          (map){
            return Video.fromJson(map);
          }
      ).toList();

    //  for( var video in dadosJson["items"]){
    //    print(video.toString());
    //  }
     // print(dadosJson["items"][1]["snippet"]["title"].toString());

      return videos;
      
    }

    return [];

  }



}