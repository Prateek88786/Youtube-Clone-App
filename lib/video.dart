import 'dart:convert';
import 'package:http/http.dart' as http;

class Video {
  String videoId;
  String channelId;
  String publishedAt;
  String channelTitle;
  String videoTitle;
  String desc;
  String thumbnail;

  Video(this.videoId, this.channelId, this.publishedAt, this.channelTitle,
      this.videoTitle, this.desc, this.thumbnail);

  static Future<List<Video>> getVideos(String query) async {
    Uri url = Uri.parse('https://www.googleapis.com/youtube/v3/search')
        .replace(queryParameters: {
      'part': 'snippet',
      'q': query,
      'key': 'AIzaSyD4dAZPa8-PZOzfOMYHUaK1g1-zyy8nxW8',
      'type': 'video',
      'videoDuration': 'long',
      'maxResults': '1000',
    });

    var response = await http.get(url);
    List<Video> videos = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      List<dynamic> items = jsonResponse['items'];

      for (var item in items) {
        var snippet = item['snippet'];
        var thumbnails = snippet['thumbnails'];

        videos.add(Video(
          item['id']?['videoId'] ?? '',
          snippet['channelId'] ?? '',
          snippet['publishedAt'] ?? '',
          snippet['channelTitle'] ?? '',
          snippet['title'] ?? '',
          snippet['description'] ?? '',
          thumbnails['high']['url'] ?? '',
        ));
      }
    } else {
      throw Exception('Failed to load videos');
    }

    return videos;
  }
}
