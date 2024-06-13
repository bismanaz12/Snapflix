// ignore_for_file: non_constant_identifier_names

import 'package:social_app/commentmodel.dart';

class ReplyComments {
  String commentId;
  String postId;
  String replycomment;
  String userId;
  List likes;
  String replyId;

  ReplyComments(
      {required this.commentId,
      required this.postId,
      required this.replycomment,
      required this.likes,
      required this.replyId,
      required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'replycomment': replycomment,
      'userId': userId,
      'postId': postId,
      'commentId': commentId,
      'likes': likes,
      'replyId': replyId
    };
  }

  factory ReplyComments.fromMap(Map<String, dynamic> map) {
    return ReplyComments(
        likes: map['likes'],
        commentId: map['commentId'],
        postId: map['postId'],
        replycomment: map['replycomment'],
        replyId: map['replyId'],
        userId: map['userId']);
  }
}
