class Users {
  String? uid;
  String? profileName;
  String? userName;
  String? imgUrl;
  String? email;
  String? bio;
  dynamic timestamp;
  List? followers;
  List? following;

  Users(
      {this.uid,
      this.profileName,
      this.userName,
      this.imgUrl,
      this.email,
      this.bio,
      this.timestamp,
      this.followers,
      this.following});

  Users.fromJson(Map<String, dynamic> userData) {
    uid = userData["uid"];
    profileName = userData["profileName"];
    userName = userData["userName"];
    imgUrl = userData["imgUrl"];
    email = userData["email"];
    bio = userData["bio"];
    timestamp = userData["timestamp"];
    followers = userData["followers"];
    following = userData["following"];
  }
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "profileName": profileName,
      "userName": userName,
      "email": email,
      "imgUrl": imgUrl,
      "bio": bio,
      "timestamp": timestamp,
      "followers": followers,
      "following": following
    };
  }
}
