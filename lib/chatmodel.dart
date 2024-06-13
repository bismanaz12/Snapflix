import 'package:cloud_firestore/cloud_firestore.dart';

class Chatmodel {
  String chatId;
  String Name;
  String senderId;
  String receiverId;
  String image;
  String message;
  DateTime time;
  messageType type;

  Chatmodel(
      {required this.Name,
      required this.chatId,
      required this.image,
      required this.message,
      required this.receiverId,
      required this.senderId,
      required this.time,
      required this.type});

  Map<String, dynamic> tomap() {
    return {
      'chatId': chatId,
      'name': Name,
      'senderId': senderId,
      'receiverId': receiverId,
      'image': image,
      'message': message,
      'time': time,
      'type': type == messageType.text
          ? 'text'
          : type == messageType.video
              ? 'video'
              : type == messageType.voice
                  ? 'voice'
                  : 'image',
    };
  }

  factory Chatmodel.fromMap(Map<String, dynamic> map) {
    return Chatmodel(
        Name: map['name'],
        chatId: map['chatId'],
        image: map['image'],
        message: map['message'],
        receiverId: map['receiverId'],
        senderId: map['senderId'],
        time: (map['time'] as Timestamp).toDate(),
        type: map['type'] == 'text'
            ? messageType.text
            : map['type'] == 'image'
                ? messageType.image
                : map['type'] == 'video'
                    ? messageType.video
                    : messageType.voice);
  }
}

enum messageType { text, video, image, voice }
