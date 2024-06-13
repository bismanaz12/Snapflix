class Commentmodel {
  String commentId;
  String postId;
  String comment;
  String userId;
  List likes;

  Commentmodel(
      {required this.comment,
      required this.commentId,
      required this.postId,
      required this.userId,
      required this.likes});

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'comment': comment,
      'postId': postId,
      'userId': userId,
      'likes': likes
    };
  }

  factory Commentmodel.fromMap(Map<String, dynamic> map) {
    return Commentmodel(
        comment: map['comment'],
        commentId: map['commentId'],
        postId: map['postId'],
        likes: map['likes'],
        userId: map['userId']);
  }
}
