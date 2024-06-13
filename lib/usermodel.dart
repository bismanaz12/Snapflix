class Usermodel {
  String name;
  String email;
  String userid;
  String password;
  String image;
  List followers;
  List followings;
  List blockUser;
  List blockBy;
  List requested;
  bool request;

  Usermodel(
      {required this.email,
      required this.blockBy,
      required this.blockUser,
      required this.name,
      required this.password,
      required this.userid,
      required this.request,
      required this.image,
      required this.followers,
      required this.requested,
      required this.followings});

  Map<String, dynamic> tomap() {
    return {
      'request': request,
      'blockUser': blockUser,
      'blockBy': blockBy,
      'userId': userid,
      'email': email,
      'username': name,
      'image': image,
      'password': password,
      'followings': followings,
      'followers': followers,
      'requested': requested
    };
  }

  factory Usermodel.frommap(Map<String, dynamic> map) {
    return Usermodel(
        request: map['request'],
        requested: map['requested'],
        blockBy: map['blockBy'],
        blockUser: map['blockUser'],
        email: map['email'],
        name: map['username'],
        password: map['password'],
        userid: map['userId'],
        image: map['image'],
        followers: map['followers'],
        followings: map['followings']);
  }
}
