import 'package:cloud_firestore/cloud_firestore.dart';

class Postmodel {
  String postId;
  String userId;
  String post;
  String caption;
  List Tags;
  DateTime time;
  List likes;
  postType posttype;
  bool pinnedpost;

  Postmodel(
      {required this.Tags,
      required this.caption,
      required this.post,
      required this.postId,
      required this.time,
      required this.userId,
      required this.likes,
      required this.posttype,
      required this.pinnedpost});

  Map<String, dynamic> tomap() {
    return {
      'userId': userId,
      'postId': postId,
      'post': post,
      'caption': caption,
      'tags': Tags,
      'time': time,
      'likes': likes,
      'pinnedpost': pinnedpost,
      'postType': posttype == postType.image ? 'image' : 'video'
    };
  }

  factory Postmodel.frommap(Map<String, dynamic> map) {
    return Postmodel(
        Tags: map['tags'],
        caption: map['caption'],
        post: map['post'],
        postId: map['postId'],
        time: (map['time'] as Timestamp).toDate(),
        userId: map['userId'],
        likes: map['likes'],
        pinnedpost: map['pinnedpost'],
        posttype: map['postType'] == 'image' ? postType.image : postType.video);
  }
}

enum postType { video, image }
