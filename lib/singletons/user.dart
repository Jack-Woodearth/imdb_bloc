import 'dart:async';

class User {
  String uid;
  String token;
  String username;
  bool isLogin;
  User(
      {this.token = '',
      this.username = '',
      this.uid = '',
      this.isLogin = false});
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'token': token,
      'username': username,
      'isLogin': isLogin,
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        token = json['token'],
        username = json['username'],
        isLogin = json['isLogin'];
}

var user = User();

final userStreamController = StreamController<User>();
