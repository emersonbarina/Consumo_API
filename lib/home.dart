import 'package:consumo_api/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  String _urlBase = "http://localhost:8080";

  String _statusCodeResposta = "StatusCode";
  String _bodyResposta = "Body";

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(Uri.parse( _urlBase + "/noticias"));
    var dadosJson = json.decode( response.body );

    List<Post> postagens = [];
    for( var post in dadosJson) {
      Post p = Post(post["id"], post["title"], post["description"]);
      postagens.add( p );
    }
    return postagens;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo API Backend"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [

                ElevatedButton(
                    onPressed: (){
                      _recuperarPostagens();
                    },
                    child: Text("Listar")
                )
              ],
            ),
            Row(
              children: [
                Text(_bodyResposta),
                Text(_statusCodeResposta)
              ],
            ),
            Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _recuperarPostagens(),
                  builder: (context, snapshot){
                    switch( snapshot.connectionState) {
                      case ConnectionState.none :
                      case ConnectionState.waiting :
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.active :
                      case ConnectionState.done :
                        if( snapshot.hasError){
                          return Scaffold(
                            appBar: AppBar(
                              title: Text("Error"),
                            ),
                            body: Center(
                              child: Text("${snapshot.error}"),
                            ),
                          );
                        }else {
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index){

                                List<Post>? lista = snapshot.data;
                                Post post = lista![index];

                                return ListTile(
                                  title: Text(post.title),
                                  subtitle: Text(post.description),
                                );
                              }
                          );
                        }
                        break;
                    }
                  }
                  ,
                )
            )
          ],
        ),
      ),
    );
  }
}
