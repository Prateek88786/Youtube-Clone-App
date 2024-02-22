import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_clone/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

late Video video;

class VideoApp extends StatefulWidget {
  VideoApp(Video v) {
    video = v;
  }

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  YoutubePlayerController _ytControl =
      YoutubePlayerController(initialVideoId: video.videoId);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            controller: _ytControl,
          ),
          Text(
            video.videoTitle,
            style: TextStyle(color: Colors.white, fontSize: 27),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Text("By ${video.channelTitle}",
                style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 20,
                )),
          ),
          SizedBox(height: 30),
          Text(
            "Description:",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Opacity(
              opacity: 0.7,
              child: Text(
                video.desc,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic),
              )),
        ],
      ),
    );
  }
}
