import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/chatpage.dart';
import 'package:social_app/frnds.dart';
import 'package:social_app/recentlymsgmodel.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 12, 8, 19),
      body: Container(
        child: Column(
          children: [
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('chats').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<RecentlyModel> Recent = [];
                    var data = snapshot.data!.docs
                        .map((e) => RecentlyModel.frommap(e.data()))
                        .toList();

                    for (var recentchat in data) {
                      if (recentchat.senderId ==
                              FirebaseAuth.instance.currentUser!.uid ||
                          recentchat.receiverId ==
                              FirebaseAuth.instance.currentUser!.uid) {
                        Recent.add(recentchat);
                      }
                    }

                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: Recent.length,
                          itemBuilder: (context, index) {
                            String id = Recent[index].senderId ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Recent[index].receiverId
                                : Recent[index].senderId;
                            String image = Recent[index].senderId ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Recent[index].receiverimage
                                : Recent[index].senderimage;
                            String name = Recent[index].senderId ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Recent[index].receivername
                                : Recent[index].sendername;

                            // return Row(
                            //   children: [
                            //     InkWell(
                            //       onTap: () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) => ChatScreen(
                            //                     Id: id,
                            //                     name: name,
                            //                     image: image)));
                            //       },
                            //       child: CircleAvatar(
                            //         radius: 30,
                            //         backgroundImage: NetworkImage(image),
                            //       ),
                            //     )
                            //   ],
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                              Id: id,
                                              image: image,
                                              name: name,
                                            )));
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 238, 96, 143)),
                                          shape: BoxShape.circle),
                                      child: CircleAvatar(
                                        radius: media.size.height * 0.03 * 1.1,
                                        backgroundImage: NetworkImage(image),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 238, 96, 143),
                                              fontSize:
                                                  media.size.height * 0.02,
                                              fontFamily: 'MyFont'),
                                        ),
                                      ),
                                    ),
                                  ])),
                            );
                          }),
                    );
                  }
                  return CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }
}
