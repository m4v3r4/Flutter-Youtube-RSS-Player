import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Showcon extends StatelessWidget {
  Future<void> share(String url, String name) async {
    await FlutterShare.share(
        title: 'Paylaş',
        text: name,
        linkUrl: 'https://www.youtube.com/watch?v=' + url,
        chooserTitle: 'Example Chooser Title');
  }

  final item;

  const Showcon({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late YoutubePlayerController _controller;

    String name = item['title'].toString();
    String id = item['yt:videoId'].toString();
    String descrip = item['media:group']['media:description']
        .toString()
        .replaceAll(RegExp(r'\\n'), ' ');
    descrip = descrip.replaceAll(RegExp(r'\\ '), '\n');

    return Scaffold(
        appBar: AppBar(
          title: Text(
            name,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: id,
                  flags: YoutubePlayerFlags(
                    hideControls: false,
                    controlsVisibleAtStart: true,
                    disableDragSeek: false,
                    autoPlay: true,
                    enableCaption: true,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Divider(),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                        decorationColor: Colors.black,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                    Divider(),
                    Text(
                      descrip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                        decorationColor: Colors.black,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                    Divider(),
                    IconButton(
                        icon: const Icon(
                          Icons.share,
                          color: Colors.red,
                        ),
                        tooltip: 'Paylaş',
                        onPressed: () {
                          share(id, name);
                        }),
                    Divider(),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
