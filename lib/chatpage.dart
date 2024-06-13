import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:social_app/bubble.dart';
import 'package:social_app/chatmodel.dart';
import 'package:social_app/imageprovider.dart';
import 'package:social_app/recentlymsgmodel.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, this.user, this.Id, this.name, this.image});

  Usermodel? user;
  String? image;
  String? Id;
  String? name;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController message = TextEditingController();

  Future<String> downloadurl(File file) async {
    String id = const Uuid().v4();
    String url = '';
    FirebaseStorage firestor = FirebaseStorage.instance;
    await firestor
        .ref()
        .child('users')
        .child('$id.png')
        .putFile(file)
        .then((p0) async {
      url = await p0.ref.getDownloadURL();
    });
    return url;
  }

  String mergeId(String receiverId) {
    String recId = widget.user == null ? widget.Id! : widget.user!.userid;
    return FirebaseAuth.instance.currentUser!.uid.hashCode <= recId.hashCode
        ? '${FirebaseAuth.instance.currentUser!.uid}_$recId'
        : '${recId}_${FirebaseAuth.instance.currentUser!.uid}';
  }

  @override
  Widget build(BuildContext context) {
    String recId = widget.user == null ? widget.Id! : widget.user!.userid;
    String recName = widget.user == null ? widget.name! : widget.user!.name;
    String recImae = widget.user == null ? widget.image! : widget.user!.image;
    var currrentuser = Provider.of<UserProvider>(context).user;
    var media = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Color.fromARGB(223, 12, 8, 19),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(mergeId(recId))
                        .collection(
                          'messages',
                        )
                        .orderBy('time', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index].data();
                              Chatmodel chat = Chatmodel.fromMap(data);

                              return Bubble(
                                  img: recImae,
                                  txt: chat.message,
                                  time: chat.time,
                                  name: recName,
                                  me: chat.senderId ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? true
                                      : false,
                                  type: chat.type);
                            });
                      }
                      return Text('Text here..');
                    }),
              ),
            ),
            Container(
              height: media.size.height * 0.1,
              color: Color.fromARGB(235, 35, 35, 65),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(0, media.size.height * 0.07),
                          shape: CircleBorder(),
                          backgroundColor: Color.fromARGB(223, 20, 14, 31)),
                      onPressed: () {},
                      child: Icon(
                        Icons.keyboard_voice,
                        color: Color.fromARGB(255, 238, 96, 143),
                        size: media.size.height * 0.03,
                      )),
                  SizedBox(
                    height: media.size.height * 0.06,
                    width: media.size.height * 0.3,
                    child: TextFormField(
                      style:
                          TextStyle(color: Color.fromARGB(255, 200, 187, 187)),
                      decoration: InputDecoration(
                          suffixIcon: PopupMenuButton(
                              icon: Icon(
                                Icons.file_copy_outlined,
                                color: Color.fromARGB(255, 200, 187, 187),
                              ),
                              onSelected: (String value) {
                                if (value == 'Photos') {
                                  Provider.of<PickProvider>(context,
                                          listen: false)
                                      .pickimage();
                                } else if (value == 'Videos') {
                                  Provider.of<PickProvider>(context,
                                          listen: false)
                                      .pickvideo();
                                } else {
                                  value = value;
                                  setState(() {});
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Text('Photos'),
                                    value: 'Photos',
                                  ),
                                  PopupMenuItem(
                                    child: Text('Videos'),
                                    value: 'Videos',
                                  ),
                                ];
                              }),
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 200, 187, 187)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 187, 187),
                                width: media.size.height * 0.001 * 0.3),
                            borderRadius: BorderRadius.all(
                                Radius.circular(media.size.height * 0.03)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 187, 187),
                                width: media.size.height * 0.001 * 0.3),
                            borderRadius: BorderRadius.all(
                                Radius.circular(media.size.height * 0.03)),
                          )),
                      controller: message,
                    ),
                  ),
                  Consumer<PickProvider>(builder: (context, pro, __) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(media.size.height * 0.03,
                              media.size.height * 0.07),
                          shape: CircleBorder(),
                          backgroundColor: Color.fromARGB(255, 238, 96, 143),
                        ),
                        onPressed: () async {
                          if (pro.image != null) {
                            String url = await downloadurl(pro.image!);

                            String chatId = Uuid().v4();
                            RecentlyModel recentchat = RecentlyModel(
                                sendername: currrentuser!.name,
                                receivername: recName,
                                senderimage: currrentuser.image,
                                message: url,
                                receiverId: recId,
                                receiverimage: recImae,
                                senderId: currrentuser.userid,
                                time: DateTime.now(),
                                userschatId: mergeId(recId),
                                type: messageType.image);
                            Chatmodel chat = Chatmodel(
                                Name: recName,
                                chatId: chatId,
                                image: recImae,
                                message: url,
                                receiverId: recId,
                                senderId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                time: DateTime.now(),
                                type: messageType.image);

                            await FirebaseFirestore.instance
                                .collection('chats')
                                .doc(mergeId(recId))
                                .collection('messages')
                                .doc(chatId)
                                .set(chat.tomap());

                            await FirebaseFirestore.instance
                                .collection('chats')
                                .doc(mergeId(recId))
                                .set(recentchat.tomap());
                            pro.setimagenull(null);
                          } else if (message.text.isNotEmpty) {
                            String chatId = Uuid().v4();
                            RecentlyModel recentchat = RecentlyModel(
                                sendername: currrentuser!.name,
                                receivername: recName,
                                senderimage: currrentuser.image,
                                message: message.text,
                                receiverId: recId,
                                receiverimage: recImae,
                                senderId: currrentuser.userid,
                                time: DateTime.now(),
                                userschatId: mergeId(recId),
                                type: messageType.text);
                            Chatmodel chat = Chatmodel(
                                Name: recName,
                                chatId: chatId,
                                image: recImae,
                                message: message.text,
                                receiverId: recId,
                                senderId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                time: DateTime.now(),
                                type: messageType.text);

                            await FirebaseFirestore.instance
                                .collection('chats')
                                .doc(mergeId(recId))
                                .collection('messages')
                                .doc(chatId)
                                .set(chat.tomap());
                            await FirebaseFirestore.instance
                                .collection('chats')
                                .doc(mergeId(recId))
                                .set(recentchat.tomap());

                            message.clear();
                          } else if (pro.video != null) {
                            String url = await downloadurl(pro.video!);
                            RecentlyModel recentchat = RecentlyModel(
                                sendername: currrentuser!.name,
                                receivername: recName,
                                senderimage: currrentuser.image,
                                message: url,
                                receiverId: recId,
                                receiverimage: recImae,
                                senderId: currrentuser.userid,
                                time: DateTime.now(),
                                userschatId: mergeId(recId),
                                type: messageType.video);

                            String chatId = Uuid().v4();
                            Chatmodel chat = Chatmodel(
                                Name: recName,
                                chatId: chatId,
                                image: recImae,
                                message: url,
                                receiverId: recId,
                                senderId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                time: DateTime.now(),
                                type: messageType.video);

                            await FirebaseFirestore.instance
                                .collection('chats')
                                .doc(mergeId(recId))
                                .collection('messages')
                                .doc(chatId)
                                .set(chat.tomap());
                            await FirebaseFirestore.instance
                                .collection('chats')
                                .doc(mergeId(recId))
                                .set(recentchat.tomap());
                            pro.setvideonull(null);
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: Color.fromARGB(223, 12, 8, 19),
                          size: media.size.height * 0.03,
                        ));
                  }),
                ],
              ),
            )
          ],
        ));
  }
}
