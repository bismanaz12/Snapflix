import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/usermodel.dart';

class NotificationModel {
  String currentuser;
  String otheruser;
  String notification;
  DateTime time;
  String notificationId;
  String postId;
  String commentId;

  NotificationModel(
      {required this.currentuser,
      required this.commentId,
      required this.notificationId,
      required this.notification,
      required this.otheruser,
      required this.postId,
      required this.time});

  Map<String, dynamic> tomap() {
    return {
      'commentId': commentId,
      'currentuser': currentuser,
      'otheruser': otheruser,
      'notification': notification,
      'postId': postId,
      'time': time,
      'NotificationId': notificationId
    };
  }

  factory NotificationModel.frommap(Map<String, dynamic> map) {
    return NotificationModel(
        commentId: map['commentId'],
        postId: map['postId'],
        notificationId: map['NotificationId'],
        currentuser: map['currentuser'],
        notification: map['notification'],
        otheruser: map['otheruser'],
        time: (map['time'] as Timestamp).toDate());
  }
}
