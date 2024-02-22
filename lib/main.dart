import 'package:flutter/material.dart';
import 'package:youtube_clone/player.dart';
import 'package:youtube_clone/search.dart';
import 'package:youtube_clone/video.dart';

void main() {
  runApp(MaterialApp(
    title: 'Youtube',
    home: App(),
  ));
}

int index = 0;
Video? playing;
int flag = 0;

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Widget createVideo(Video video) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: () {
              playing = video;
              navigateToVideoPlayer(video);
            },
            child: Image.network(video.thumbnail, fit: BoxFit.cover)),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Text(video.videoTitle,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        SizedBox(
          height: 5,
        ),
        Opacity(
          opacity: 0.4,
          child: Text(video.desc,
              style: TextStyle(color: Colors.white, fontSize: 10)),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget createList() {
    return FutureBuilder<List<Video>>(
      future: Video.getVideos('trending videos in India'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Video> videos = snapshot.data ?? [];
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return createVideo(videos[index]);
            },
          );
        }
      },
    );
  }

  void navigateToVideoPlayer(Video video) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SafeArea(
                  child: Container(
                    color: Colors.black,
                    child: Scaffold(
                        backgroundColor: Colors.black,
                       
                        body: VideoApp(video)),
                  ),
                )));
  }

  void navigateToSearch() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SafeArea(
          child: Container(
            color: Colors.black,
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                leading: Image.network(
                    'https://cdn-icons-png.flaticon.com/256/1384/1384060.png',
                    fit: BoxFit.cover),
                backgroundColor: Colors.black,
                title: Row(children: [
                  Text("YouTube",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ]),
                actions: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.cast,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () {
                        navigateToSearch();
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              body: Container(
                child: createList(),
              ),
            ),
          ),
        ));
  }
}
