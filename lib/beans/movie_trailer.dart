import 'details.dart';

class MovieTrailerBean {
  // String movieTitle = '';
  String trailerCover = '';
  String trailerTime = '';
  String videoId = '';
  // String mid = '';
  MovieBean? movieBean;
  MovieTrailerBean(
      {
      // required this.movieTitle,
      required this.trailerCover,
      required this.trailerTime,
      required this.videoId,
      required this.movieBean
      // required this.mid,
      });

  MovieTrailerBean.fromJson(Map<String, dynamic> json) {
    // if (json["movie_title"] is String) this.movieTitle = json["movie_title"];
    // if (json["mid"] is String) this.movieTitle = json["mid"];
    if (json["trailer_cover"] is String)
      this.trailerCover = json["trailer_cover"];
    if (json["trailer_time"] is String) this.trailerTime = json["trailer_time"];
    if (json["video_id"] is String) this.videoId = json["video_id"];

    try {
      movieBean = MovieBean.fromJson(json['movie']);
    } catch (e) {
      // TODO
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data["movie_title"] = this.movieTitle;
    data["trailer_cover"] = this.trailerCover;
    data["trailer_time"] = this.trailerTime;
    data["video_id"] = this.videoId;
    data["movie_bean"] = this.movieBean;

    // data["mid"] = this.mid;
    return data;
  }
}
