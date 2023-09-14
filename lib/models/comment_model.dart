import 'package:cloud_firestore/cloud_firestore.dart';

final userRef = FirebaseFirestore.instance.collection("users");

class Comments {
  String? commenterUserId;
  String? commentId;
  String? comment;

  Comments({this.commenterUserId, this.commentId, this.comment});

  Comments.fromJson(Map<String, dynamic> json) {
    commenterUserId = json["commenterUserId"];
    comment = json["comment"];
    commentId = json["commentId"];
  }
  Map<String, dynamic> toMap() {
    return {
      "commenterUserId": commenterUserId,
      "comment": comment,
      "commentId": commentId
    };
  }

  Future<String> getUserName(String uid) async {
    Map<String, dynamic> map = {};
    await userRef.doc(uid).get().then((value) {
      map = value.data() as Map<String, dynamic>;
    });
    return map["userName"];
  }
}
