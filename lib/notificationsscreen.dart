import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/myprofile.dart';
import 'package:social_app/notificationmodel.dart';
import 'package:social_app/postmodel.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({
    super.key,
    required this.user,
  });
  Usermodel user;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 12, 8, 19),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: media.size.height * 0.08,
            ),
            Text(
              'Notifications',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MyFont',
                  fontSize: media.size.height * 0.02),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('otheruser',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data();
                          NotificationModel modelnot =
                              NotificationModel.frommap(data);

                          // return Text(
                          //   modelnot.notification,
                          //   style: TextStyle(color: Colors.white),
                          // );

                          return modelnot.notification.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: media.size.height * 0.02),
                                  child: Row(
                                    children: [
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(modelnot.currentuser)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var data = snapshot.data!.data();
                                              Usermodel model =
                                                  Usermodel.frommap(data!);

                                              return CircleAvatar(
                                                radius:
                                                    media.size.height * 0.03,
                                                backgroundImage:
                                                    NetworkImage(model.image),
                                              );
                                            }
                                            return Text('');
                                          }),
                                      Expanded(
                                          child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(modelnot.currentuser)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var data =
                                                    snapshot.data!.data();
                                                Usermodel model =
                                                    Usermodel.frommap(data!);
                                                return Text(
                                                  model.name,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'regular',
                                                      fontSize:
                                                          media.size.height *
                                                              0.02 *
                                                              1.1),
                                                );
                                              }
                                              return Text('');
                                            }),
                                      )),
                                      InkWell(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('notifications')
                                              .doc(modelnot.notificationId)
                                              .delete();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              fontSize: media.size.height *
                                                  0.02 *
                                                  1.1,
                                              color: Color.fromARGB(
                                                  255, 238, 96, 143),
                                            ),
                                          ),
                                        ),
                                      ),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(modelnot.currentuser)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var data = snapshot.data!.data();
                                              Usermodel model =
                                                  Usermodel.frommap(data!);
                                              return ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  238,
                                                                  96,
                                                                  143),
                                                          fixedSize: Size(
                                                              media.size
                                                                      .height *
                                                                  0.1 *
                                                                  1.3,
                                                              media.size
                                                                      .height *
                                                                  0.04)),
                                                  onPressed: () {
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .confimrId(
                                                            model,
                                                            user,
                                                            modelnot
                                                                .notificationId);
                                                  },
                                                  child: Text(
                                                    'confirm',
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            223, 12, 8, 19),
                                                        fontSize:
                                                            media.size.height *
                                                                0.02),
                                                  ));
                                            }
                                            return Text('');
                                          })
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      top: media.size.height * 0.02),
                                  child: Row(
                                    children: [
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(modelnot.currentuser)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var data = snapshot.data!.data();
                                              Usermodel model =
                                                  Usermodel.frommap(data!);
                                              return CircleAvatar(
                                                radius:
                                                    media.size.height * 0.03,
                                                backgroundImage:
                                                    NetworkImage(model.image),
                                              );
                                            }
                                            return Text('');
                                          }),
                                      Expanded(
                                          child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(modelnot.currentuser)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var data =
                                                    snapshot.data!.data();
                                                Usermodel model =
                                                    Usermodel.frommap(data!);
                                                return Text(
                                                  model.name,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'regular',
                                                      fontSize:
                                                          media.size.height *
                                                              0.02 *
                                                              1.1),
                                                );
                                              }
                                              return Text('');
                                            }),
                                      )),
                                      Expanded(
                                          child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          modelnot.notification,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'regular',
                                              fontSize:
                                                  media.size.height * 0.02),
                                        ),
                                      )),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Post')
                                              .doc(modelnot.postId)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var data = snapshot.data!.data();
                                              Postmodel post =
                                                  Postmodel.frommap(data!);

                                              return post.posttype ==
                                                      postType.image
                                                  ? Container(
                                                      height:
                                                          media.size.height *
                                                              0.05,
                                                      width: media.size.height *
                                                          0.05,
                                                      child: Image.network(
                                                          post.post),
                                                    )
                                                  : Container(
                                                      height:
                                                          media.size.height *
                                                              0.05,
                                                      width: media.size.height *
                                                          0.05,
                                                      child: NotiPlayer(
                                                          videoplayer:
                                                              post.post),
                                                    );
                                            }
                                            return Text('');
                                          })
                                    ],
                                  ));

                          // return StreamBuilder(
                          //     stream: FirebaseFirestore.instance
                          //         .collection('users')
                          //         .doc(modelnot.currentuser)
                          //         .snapshots(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.hasData) {
                          //         var data = snapshot.data!.data();
                          //         Usermodel model = Usermodel.frommap(data!);

                          //         return modelnot.notification.isEmpty
                          //             ? Padding(
                          //                 padding: EdgeInsets.only(
                          //                     top: media.size.height * 0.02),
                          //                 child: Row(
                          //                   children: [
                          //                     CircleAvatar(
                          //                       radius:
                          //                           media.size.height * 0.03,
                          //                       backgroundImage:
                          //                           NetworkImage(model.image),
                          //                     ),
                          //                     Expanded(
                          //                         child: Container(
                          //                       padding: EdgeInsets.symmetric(
                          //                           horizontal: 10),
                          //                       child: Text(
                          //                         model.name,
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontFamily: 'regular',
                          //                             fontSize:
                          //                                 media.size.height *
                          //                                     0.02 *
                          //                                     1.1),
                          //                       ),
                          //                     )),
                          //                     InkWell(
                          //                       onTap: () async {
                          //                         await FirebaseFirestore
                          //                             .instance
                          //                             .collection(
                          //                                 'notifications')
                          //                             .doc(modelnot
                          //                                 .notificationId)
                          //                             .delete();
                          //                       },
                          //                       child: Container(
                          //                         padding:
                          //                             EdgeInsets.symmetric(
                          //                                 horizontal: 10),
                          //                         child: Text(
                          //                           'Delete',
                          //                           style: TextStyle(
                          //                             fontSize:
                          //                                 media.size.height *
                          //                                     0.02 *
                          //                                     1.1,
                          //                             color: Color.fromARGB(
                          //                                 255, 238, 96, 143),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     ElevatedButton(
                          //                         style:
                          //                             ElevatedButton.styleFrom(
                          //                                 backgroundColor:
                          //                                     Color.fromARGB(
                          //                                         255,
                          //                                         238,
                          //                                         96,
                          //                                         143),
                          //                                 fixedSize: Size(
                          //                                     media.size
                          //                                             .height *
                          //                                         0.1 *
                          //                                         1.3,
                          //                                     media.size
                          //                                             .height *
                          //                                         0.04)),
                          //                         onPressed: () {
                          //                           Provider.of<UserProvider>(
                          //                                   context,
                          //                                   listen: false)
                          //                               .confimrId(
                          //                                   model,
                          //                                   user,
                          //                                   modelnot
                          //                                       .notificationId);
                          //                         },
                          //                         child: Text(
                          //                           'confirm',
                          //                           style: TextStyle(
                          //                               color: const Color
                          //                                   .fromARGB(
                          //                                   223, 12, 8, 19),
                          //                               fontSize: media
                          //                                       .size.height *
                          //                                   0.02),
                          //                         ))
                          //                   ],
                          //                 ),
                          //               )
                          //             : Padding(
                          //                 padding: EdgeInsets.only(
                          //                     top: media.size.height * 0.02),
                          //                 child: Row(
                          //                   children: [
                          //                     CircleAvatar(
                          //                       radius:
                          //                           media.size.height * 0.03,
                          //                       backgroundImage:
                          //                           NetworkImage(model.image),
                          //                     ),
                          //                     Expanded(
                          //                         child: Container(
                          //                       padding: EdgeInsets.symmetric(
                          //                           horizontal: 10),
                          //                       child: Text(
                          //                         model.name,
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontFamily: 'regular',
                          //                             fontSize:
                          //                                 media.size.height *
                          //                                     0.02 *
                          //                                     1.1),
                          //                       ),
                          //                     )),
                          //                     Expanded(
                          //                         child: Container(
                          //                       padding: EdgeInsets.symmetric(
                          //                           horizontal: 10),
                          //                       child: Text(
                          //                         modelnot.notification,
                          //                         style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontFamily: 'regular',
                          //                             fontSize:
                          //                                 media.size.height *
                          //                                     0.02),
                          //                       ),
                          //                     )),
                          //                     StreamBuilder(
                          //                         stream: FirebaseFirestore
                          //                             .instance
                          //                             .collection('Post')
                          //                             .doc(modelnot.postId)
                          //                             .snapshots(),
                          //                         builder:
                          //                             (context, snapshot) {
                          //                           if (snapshot.hasData) {
                          //                             var data = snapshot
                          //                                 .data!
                          //                                 .data();
                          //                             Postmodel post =
                          //                                 Postmodel.frommap(
                          //                                     data!);

                          //                             return post.posttype ==
                          //                                     postType.image
                          //                                 ? Container(
                          //                                     height: media
                          //                                             .size
                          //                                             .height *
                          //                                         0.05,
                          //                                     width: media
                          //                                             .size
                          //                                             .height *
                          //                                         0.05,
                          //                                     child: Image
                          //                                         .network(post
                          //                                             .post),
                          //                                   )
                          //                                 : Container(
                          //                                     height: media
                          //                                             .size
                          //                                             .height *
                          //                                         0.05,
                          //                                     width: media
                          //                                             .size
                          //                                             .height *
                          //                                         0.05,
                          //                                     child: NotiPlayer(
                          //                                         videoplayer:
                          //                                             post.post),
                          //                                   );
                          //                           }
                          //                           return Text('');
                          //                         })
                          //                   ],
                          //                 ),
                          //               );
                          //       }
                          //       return Text('');
                          //     });
                        });
                  }
                  return const CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}

class NotificationContainer extends StatelessWidget {
  NotificationContainer(
      {super.key, required this.Id, required this.user, required this.notiId});
  String Id;
  Usermodel user;
  String notiId;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(Id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.data();
            Usermodel model = Usermodel.frommap(data!);
            return Container(
              height: media.size.height * 0.1,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Color.fromARGB(255, 238, 96, 143)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: media.size.height * 0.001,
                          color: Color.fromARGB(223, 12, 8, 19),
                        )),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(model.image),
                      radius: media.size.height * 0.06,
                    ),
                  ),
                  Text(
                    model.name,
                    style: TextStyle(
                        color: Color.fromARGB(223, 12, 8, 19),
                        fontSize: media.size.height * 0.02,
                        fontFamily: 'MyFont'),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(223, 12, 8, 19),
                          fixedSize: Size(media.size.height * 0.2,
                              media.size.height * 0.04)),
                      onPressed: () {
                        Provider.of<UserProvider>(context, listen: false)
                            .confimrId(model, user, notiId);
                      },
                      child: Text(
                        'confirm',
                        style: TextStyle(
                            color: Color.fromARGB(255, 238, 96, 143),
                            fontSize: media.size.height * 0.02),
                      ))
                ],
              ),
            );
          }
          return Text('');
        });
  }
}

class NotiPlayer extends StatefulWidget {
  NotiPlayer({super.key, required this.videoplayer});
  String videoplayer;

  @override
  State<NotiPlayer> createState() => _NotiPlayerState();
}

class _NotiPlayerState extends State<NotiPlayer> {
  late CachedVideoPlayerPlusController videocontroller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      videocontroller = CachedVideoPlayerPlusController.networkUrl(
          Uri.parse(widget.videoplayer.toString()));
    });
    videocontroller.initialize();
    videocontroller.play();
    videocontroller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    videocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return CachedVideoPlayerPlus(videocontroller);
  }
}
