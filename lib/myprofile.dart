import 'dart:developer';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:social_app/editprofile.dart';
import 'package:social_app/imageprovider.dart';
import 'package:social_app/login.dart';
import 'package:social_app/postmodel.dart';
import 'package:social_app/postprovider.dart';
import 'package:social_app/sharepref.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';

class MyProfile extends StatefulWidget {
  MyProfile({super.key, required this.value});
  bool value;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).getUsers();
    var media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(223, 12, 8, 19),
      body: Consumer<UserProvider>(builder: (context, pro, _) {
        return Column(children: [
          SizedBox(
            height: media.size.height * 0.1 * 0.6,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: CircleBorder(
                    side: BorderSide(
                        color: const Color.fromARGB(255, 238, 96, 143),
                        width: media.size.height * 0.002))),
            onPressed: () {},
            child: CircleAvatar(
              radius: media.size.height * 0.07,
              backgroundImage: NetworkImage(pro.user!.image),
            ),
          ),
          SizedBox(
            height: media.size.height * 0.01,
          ),
          Text(
            '${pro.user!.name}',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'MyFont',
                fontSize: media.size.height * 0.02),
          ),
          SizedBox(
            height: media.size.height * 0.01,
          ),
          Text(
            '${pro.user!.email}',
            style: const TextStyle(
                color: Color.fromARGB(255, 200, 187, 187),
                fontFamily: 'regular'),
          ),
          SizedBox(
            height: media.size.height * 0.02,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfile(
                            value: widget.value,
                          )));
            },
            child: Center(
              child: Text(
                'Edit Profile',
                style: TextStyle(
                    color: const Color.fromARGB(255, 238, 96, 143),
                    fontFamily: 'MyFont',
                    fontSize: media.size.height * 0.02 * 1.1),
              ),
            ),
          ),
          SizedBox(
            height: media.size.height * 0.02,
          ),
          Container(
            height: media.size.height * 0.1 * 1.3,
            width: media.size.height * 0.1 * 3.8,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 238, 96, 143),
              borderRadius: BorderRadius.all(Radius.circular(45)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: media.size.height * 0.02,
                  right: media.size.height * 0.02,
                  top: media.size.height * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Stack(children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      height: media.size.height * 0.4 * 1.3,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Followers',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: media.size.height *
                                                  0.02 *
                                                  1.2,
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.black,
                                            thickness:
                                                media.size.height * 0.001,
                                          ),
                                          StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('users')
                                                  .where('userId',
                                                      whereIn:
                                                          pro.user!.followers)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  var data = snapshot.data!.docs
                                                      .map((e) =>
                                                          Usermodel.frommap(
                                                              e.data()))
                                                      .toList();

                                                  if (data.isEmpty) {
                                                    return const Text('');
                                                  }

                                                  return ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: data.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                              top: media.size
                                                                      .height *
                                                                  0.02),
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: media
                                                                        .size
                                                                        .height *
                                                                    0.03,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data[index]
                                                                            .image),
                                                              ),
                                                              Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        15),
                                                                child: Expanded(
                                                                  child: Text(
                                                                    data[index]
                                                                        .name,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'MyFont',
                                                                        fontSize:
                                                                            media.size.height *
                                                                                0.02,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                }
                                                return const Text('');
                                              }),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 280,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.cancel_outlined),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ]),
                                );
                              });
                        },
                        child: Text(
                          'Followers',
                          style: TextStyle(
                              color: const Color.fromARGB(223, 12, 8, 19),
                              fontFamily: 'MyFont',
                              fontSize: media.size.height * 0.02),
                        ),
                      ),
                      Text(
                        '${pro.user!.followers.length}',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'regular',
                            fontSize: media.size.height * 0.02),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Stack(children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      height: media.size.height * 0.4 * 1.3,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Followings',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: media.size.height *
                                                  0.02 *
                                                  1.2,
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.black,
                                            thickness:
                                                media.size.height * 0.001,
                                          ),
                                          // StreamBuilder(
                                          //     stream: FirebaseFirestore.instance
                                          //         .collection('users')
                                          //         .where('userId',
                                          //             whereIn:
                                          //                 pro.user!.followings)
                                          //         .snapshots(),
                                          //     builder: (context, snapshot) {
                                          //       if (snapshot.hasData) {
                                          //         var data = snapshot.data!.docs
                                          //             .map((e) =>
                                          //                 Usermodel.frommap(
                                          //                     e.data()))
                                          //             .toList();

                                          //         return ListView.builder(
                                          //             shrinkWrap: true,
                                          //             itemCount: data.length,
                                          //             itemBuilder:
                                          //                 (context, index) {
                                          //               return Padding(
                                          //                 padding: EdgeInsets.only(
                                          //                     top: media.size
                                          //                             .height *
                                          //                         0.02),
                                          //                 child: Row(
                                          //                   children: [
                                          //                     CircleAvatar(
                                          //                       radius: media
                                          //                               .size
                                          //                               .height *
                                          //                           0.03,
                                          //                       backgroundImage:
                                          //                           NetworkImage(
                                          //                               data[index]
                                          //                                   .image),
                                          //                     ),
                                          //                     Container(
                                          //                       padding: EdgeInsets
                                          //                           .symmetric(
                                          //                               horizontal:
                                          //                                   15),
                                          //                       child: Expanded(
                                          //                         child: Text(
                                          //                           data[index]
                                          //                               .name,
                                          //                           style: TextStyle(
                                          //                               color: Colors
                                          //                                   .black,
                                          //                               fontFamily:
                                          //                                   'MyFont',
                                          //                               fontSize:
                                          //                                   media.size.height *
                                          //                                       0.02,
                                          //                               fontWeight:
                                          //                                   FontWeight.bold),
                                          //                         ),
                                          //                       ),
                                          //                     ),
                                          //                   ],
                                          //                 ),
                                          //               );
                                          //             });
                                          //       }
                                          //       return Text('');
                                          //     }),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 280,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.cancel_outlined),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ]),
                                );
                              });
                        },
                        child: Text(
                          'Followings',
                          style: TextStyle(
                              color: const Color.fromARGB(223, 12, 8, 19),
                              fontFamily: 'MyFont',
                              fontSize: media.size.height * 0.02),
                        ),
                      ),
                      Text(
                        '${pro.user!.followings.length}',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'regular',
                            fontSize: media.size.height * 0.02),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Posts',
                        style: TextStyle(
                            color: const Color.fromARGB(223, 12, 8, 19),
                            fontFamily: 'MyFont',
                            fontSize: media.size.height * 0.02),
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Post')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.docs
                                  .map((e) => Postmodel.frommap(e.data()))
                                  .toList();
                              return Text(
                                '${data.length}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'regular',
                                    fontSize: media.size.height * 0.02),
                              );
                            }
                            return const Text('');
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: media.size.height * 0.01,
          ),
          MyData(value1: value1, value2: value2),
        ]);
      }),
    );
  }
}

class MyData extends StatefulWidget {
  MyData({
    super.key,
    required this.value1,
    required this.value2,
  });
  bool value1;
  bool value2;

  @override
  State<MyData> createState() => _MyDataState();
}

class _MyDataState extends State<MyData> {
  List<String> ids = [];
  @override
  void initState() {
    // getSavedIds();
    // SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
    // Provider.of<PostProvider>(context, listen: false).getCureentuserPost();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Consumer<PostProvider>(builder: (context, pro, _) {
      List pinnedpost = [];
      List unpinnedpost = [];
      for (var post in pro.allposts) {
        if (post.pinnedpost) {
          pinnedpost.add(post);
        } else {
          unpinnedpost.add(post);
        }
      }
      List allpost = [...pinnedpost, ...unpinnedpost];
      return Expanded(
        child: GridView.builder(
            // physics: ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: media.size.height * 0.30, crossAxisCount: 2),
            itemCount: allpost.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Postmodel post = allpost[index];
              return post.posttype == postType.video
                  ? InkWell(
                      onTap: () {
                        bool ispinned = post.pinnedpost;
                        ispinned = !ispinned;
                        Provider.of<PostProvider>(context, listen: false)
                            .pinpost(ispinned, post.postId);
                      },
                      child: post.pinnedpost
                          ? Stack(children: [
                              Container(
                                  height: media.size.height * 0.30,
                                  width: media.size.height * 0.3,
                                  child: PostPlayer(videoplayer: post.post)),
                              const Positioned(
                                  top: 10,
                                  child: Icon(
                                    Icons.push_pin,
                                    color: Colors.white,
                                  ))
                            ])
                          : Container(
                              height: media.size.height * 0.30,
                              width: media.size.height * 0.3,
                              child: PostPlayer(videoplayer: post.post)),
                    )
                  : InkWell(
                      onTap: () {
                        bool ispinned = post.pinnedpost;
                        ispinned = !ispinned;
                        Provider.of<PostProvider>(context, listen: false)
                            .pinpost(ispinned, post.postId);
                      },
                      child: post.pinnedpost
                          ? Stack(children: [
                              Container(
                                width: media.size.height * 0.30,
                                height: media.size.height * 0.1 * 3,
                                child:
                                    Image.network(post.post, fit: BoxFit.cover),
                              ),
                              const Positioned(
                                  top: 10,
                                  child: Icon(
                                    Icons.push_pin,
                                    color: Colors.white,
                                  ))
                            ])
                          : Container(
                              width: media.size.height * 0.30,
                              height: media.size.height * 0.1 * 3,
                              child:
                                  Image.network(post.post, fit: BoxFit.cover),
                            ),
                    );

              // : Container();
            }),
      );
    });
  }
}

// class PostPlayer extends StatefulWidget {
//   PostPlayer({super.key, required this.videoplayer});
//   String videoplayer;

//   @override
//   State<Player> createState() => _PlayerState();
// }

// class _PlayerState extends State<Player> {
//   late CachedVideoPlayerPlusController videocontroller;

//   @override
//   Widget build(BuildContext context) {

// }

class PostPlayer extends StatefulWidget {
  PostPlayer({super.key, required this.videoplayer});
  String videoplayer;

  @override
  State<PostPlayer> createState() => _PostPlayerState();
}

class _PostPlayerState extends State<PostPlayer> {
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
    return Container(
        width: media.size.height * 0.2,
        height: media.size.height * 0.23,
        child: CachedVideoPlayerPlus(videocontroller));
  }
}
