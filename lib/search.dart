import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_clone/player.dart';
import 'package:youtube_clone/video.dart';

Video? playing;
String query = '';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
      future: Video.getVideos(query),
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
                        backgroundColor: Colors.black, body: VideoApp(video)),
                  ),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        onChanged: (text) {
                          query = text;
                          setState(() {});
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 13),
                          fillColor: Colors.black12,
                          hintText: "Search YouTube",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                    if (query != '')
                      Container(
                        height: MediaQuery.of(context).size.height - 100,
                        child: createList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
