import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import 'video.dart';

Xml2Json xml2json = new Xml2Json();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Future<List> _getVieos() async {
    final ura = "www.youtube.com";
    final api = "/feeds/videos.xml";
    final _params = {"playlist_id": "PLH-8iHMW2k5W6wH9RszrAn-Cbg4S_yEij"};
    final url = Uri.https(ura, api, _params);
    print(url);
    http.Response response = await http.get(url);
    xml2json.parse(response.body);
    var jsondata = xml2json.toParker();
    var jsonData = json.decode(jsondata);

    var videoList = [];
    var videos = jsonData['feed']['entry'];
    for (var item in videos) {
      videoList.add(item);
    }

    return videoList;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(""),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: _getVieos(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("None");
              case ConnectionState.waiting:
                return SpinKitRotatingCircle(color: Colors.black);
              case ConnectionState.done:
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Divider(),
                        ListTile(
                          leading: Container(
                            height: 150,
                            width: 150,
                            child: Image.network(
                              'https://i4.ytimg.com/vi/' +
                                  snapshot.data[index]['yt:videoId'] +
                                  '/hqdefault.jpg',
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                            ),
                          ),
                          hoverColor: Colors.red,
                          selectedColor: Colors.red,
                          title: Text(snapshot.data[index]['title']),
                          subtitle: Text(
                              snapshot.data[index]['published'].toString()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Showcon(
                                        item: snapshot.data[index],
                                      )),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              case ConnectionState.active:
                return Container(
                    child: Center(
                        child: Text(snapshot.hasData.hashCode.toString())));
            }
          },
        ),
      ),
    );
  }
}
