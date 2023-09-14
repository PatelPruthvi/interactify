// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// class Posts {
//   final String caption;
//   final String location;
//   final String timestamp;
//   final String userName;
//   final String postId;
//   final List imgUrl;
//   final dynamic likes;
//   final String ownerId;

//   Posts(this.caption, this.location, this.timestamp, this.userName, this.postId,
//       this.imgUrl, this.likes, this.ownerId);

//   Map<String, dynamic> toMap() {
//     return {
//       "postId": postId,
//       "ownerId": ownerId,
//       "likes": [],
//       "userName": userName,
//       "timestamp": DateTime.now(),
//       "caption": caption,
//       "location": location,
//       "images": imgUrl
//     };
//   }

//   Posts.fromJSON(Map<String, dynamic> json) {
//     caption = ;
//   }
// }
class Posts {
  String? postId;
  String? ownerId;
  List<String>? likes;
  String? userName;
  dynamic timestamp;
  String? caption;
  String? location;
  List<String>? images;

  Posts(
      {this.postId,
      this.ownerId,
      this.likes,
      this.userName,
      this.timestamp,
      this.caption,
      this.location,
      this.images});

  Posts.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    ownerId = json['ownerId'];
    likes = json['likes'].cast<String>();
    userName = json['userName'];

    String timeOfPosting = "";
    Timestamp postTime = json["timestamp"];
    int diff = ((DateTime.now().millisecondsSinceEpoch -
                postTime.toDate().millisecondsSinceEpoch) *
            0.001)
        .ceil();
    if (diff < 15) {
      timeOfPosting = "few seconds ago";
    } else if (diff < 60) {
      timeOfPosting = "$diff seconds ago";
    } else if (diff < 3600) {
      timeOfPosting = "${(diff / 60).toStringAsFixed(0)} minutes ago";
    } else if (diff < 86400) {
      timeOfPosting = "${(diff / 3600).ceil()} hours ago";
    } else {
      timeOfPosting = DateFormat.MMMMd().format(postTime.toDate()).toString();
    }
    timestamp = timeOfPosting;
    caption = json['caption'];
    location = json['location'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postId'] = postId;
    data['ownerId'] = ownerId;
    data['likes'] = likes;
    data['userName'] = userName;
    data['timestamp'] = timestamp;
    data['caption'] = caption;
    data['location'] = location;
    data['images'] = images;
    return data;
  }
}
