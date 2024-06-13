import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/chatmodel.dart';

class RecentlyModel {
  String senderId;
  String receiverId;
  String senderimage;
  String receiverimage;
  String sendername;
  String receivername;

  String message;
  DateTime time;
  messageType type;
  String userschatId;

  RecentlyModel(
      {required this.senderimage,
      required this.message,
      required this.receiverId,
      required this.receiverimage,
      required this.senderId,
      required this.time,
      required this.userschatId,
      required this.receivername,
      required this.sendername,
      required this.type});

  Map<String, dynamic> tomap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'senderimage': senderimage,
      'receiverimage': receiverimage,
      'time': time,
      'receivername': receiverId,
      'sendername': sendername,
      'type': type == messageType.text
          ? 'text'
          : type == messageType.video
              ? 'video'
              : type == messageType.voice
                  ? 'voice'
                  : 'image',
      'message': message,
      'userschatId': userschatId
    };
  }

  factory RecentlyModel.frommap(Map<String, dynamic> map) {
    return RecentlyModel(
        receivername: map['receivername'],
        sendername: map['sendername'],
        senderimage: map['senderimage'],
        message: map['message'],
        receiverId: map['receiverId'],
        receiverimage: map['receiverimage'],
        senderId: map['senderId'],
        time: (map['time'] as Timestamp).toDate(),
        userschatId: map['userschatId'],
        type: map['type'] == 'text'
            ? messageType.text
            : map['type'] == 'image'
                ? messageType.image
                : map['type'] == 'video'
                    ? messageType.video
                    : messageType.voice);
  }
}
