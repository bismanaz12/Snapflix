import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_app/postmodel.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';

class OtherUserProfile extends StatefulWidget {
  OtherUserProfile(
      {super.key, required this.otheruser, required this.otheruserId});
  Usermodel? otheruser;
  String otheruserId;

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    var otheruser = Provider.of<UserProvider>(
      context,
    ).otheruser;

    Provider.of<UserProvider>(context, listen: false)
        .getotheruser(widget.otheruserId);
    var media = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(223, 12, 8, 19),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.otheruser!.userid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.data();
              Usermodel usermodel = Usermodel.frommap(data!);
              return Column(children: [
                SizedBox(
                  height: media.size.height * 0.1 * 0.6,
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: CircleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 238, 96, 143),
                              width: media.size.height * 0.002))),
                  onPressed: () {},
                  child: CircleAvatar(
                    radius: media.size.height * 0.07,
                    backgroundImage: NetworkImage(usermodel.image),
                  ),
                ),

                SizedBox(
                  height: media.size.height * 0.01,
                ),
                Text(
                  usermodel.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MyFont',
                      fontSize: media.size.height * 0.02),
                ),
                SizedBox(
                  height: media.size.height * 0.01,
                ),
                Text(
                  usermodel.email,
                  style: TextStyle(
                      color: Color.fromARGB(255, 200, 187, 187),
                      fontFamily: 'regular'),
                ),
                SizedBox(
                  height: media.size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(left: media.size.height * 0.12),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 238, 96, 143),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            fixedSize: Size(media.size.height * 0.2,
                                media.size.height * 0.05)),
                        onPressed: () {
                          Provider.of<UserProvider>(context, listen: false)
                              .requestUser(user, otheruser);
                        },
                        child: Text(
                          otheruser!.followers.contains(user!.userid)
                              ? 'Following'
                              : otheruser.requested.contains(user!.userid)
                                  ? 'Requested'
                                  : 'Follow',
                          style: TextStyle(
                              color: Color.fromARGB(223, 12, 8, 19),
                              fontFamily: 'MyFont',
                              fontSize: media.size.height * 0.02 * 1.1),
                        ),
                      ),
                      PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Color.fromARGB(255, 238, 96, 143),
                            size: media.size.height * 0.03,
                          ),
                          onSelected: (value) {
                            if (value == 'Block') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        height: media.size.height * 0.3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: media.size.height * 0.02,
                                            ),
                                            CircleAvatar(
                                              radius: media.size.height * 0.05,
                                              backgroundImage:
                                                  NetworkImage(usermodel.image),
                                            ),
                                            Container(
                                                width: media.size.height * 0.3,
                                                child: Expanded(
                                                  child: Text(
                                                      "If you change your mind, you'll have to request to follow ${usermodel.name} again."),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 238, 96, 143),
                                                    fixedSize: Size(
                                                        media.size.height *
                                                            0.1 *
                                                            1.5,
                                                        media.size.height *
                                                            0.02)),
                                                onPressed: () {
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .BlockUser(
                                                          user, otheruser);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  otheruser.blockBy
                                                          .contains(user.userid)
                                                      ? 'Unblock'
                                                      : 'Block',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          223, 12, 8, 19),
                                                      fontSize:
                                                          media.size.height *
                                                              0.02),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    fixedSize: Size(
                                                        media.size.height *
                                                            0.1 *
                                                            1.5,
                                                        media.size.height *
                                                            0.02)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          223, 12, 8, 19),
                                                      fontSize:
                                                          media.size.height *
                                                              0.02),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else {}
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: Text(
                                    otheruser.blockBy.contains(user.userid)
                                        ? 'Unblock'
                                        : 'Block'),
                                value: 'Block',
                              ),
                              PopupMenuItem(
                                child: Text('Share To'),
                                value: 'Share To',
                              ),
                            ];
                          }),
                      // Icon(
                      //   Icons.more_vert,
                      //   color: Color.fromARGB(255, 238, 96, 143),
                      //   size: media.size.height * 0.03,
                      // ),
                    ],
                  ),
                ),

                SizedBox(
                  height: media.size.height * 0.02,
                ),
                Container(
                  height: media.size.height * 0.1 * 1.3,
                  width: media.size.height * 0.1 * 3.8,
                  decoration: BoxDecoration(
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            height:
                                                media.size.height * 0.4 * 1.3,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Followers',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        media.size.height *
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
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .where('userId',
                                                            whereIn: usermodel
                                                                    .followers
                                                                    .isEmpty
                                                                ? []
                                                                : usermodel
                                                                    .followers)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!.docs
                                                            .map((e) => Usermodel
                                                                .frommap(
                                                                    e.data()))
                                                            .toList();

                                                        return ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                data.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: media
                                                                            .size
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
                                                                              data[index].image),
                                                                    ),
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              15),
                                                                      child:
                                                                          Expanded(
                                                                        child:
                                                                            Text(
                                                                          data[index]
                                                                              .name,
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: 'MyFont',
                                                                              fontSize: media.size.height * 0.02,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    data[index].userid ==
                                                                            user
                                                                                .userid
                                                                        ? Text(
                                                                            '')
                                                                        : Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: media.size.height * 0.02),
                                                                            child:
                                                                                ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 238, 96, 143), fixedSize: Size(media.size.height * 0.1 * 1.5, media.size.height * 0.02)),
                                                                              onPressed: () {
                                                                                !user.followings.contains(data[index].userid)
                                                                                    ? Provider.of<UserProvider>(context, listen: false).followuser(data[index], user)
                                                                                    : showDialog(
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          return Dialog(
                                                                                            child: Container(
                                                                                              padding: EdgeInsets.symmetric(
                                                                                                horizontal: 20,
                                                                                              ),
                                                                                              height: media.size.height * 0.3,
                                                                                              child: Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    height: media.size.height * 0.02,
                                                                                                  ),
                                                                                                  CircleAvatar(
                                                                                                    radius: media.size.height * 0.05,
                                                                                                    backgroundImage: NetworkImage(data[index].image),
                                                                                                  ),
                                                                                                  Container(
                                                                                                      width: media.size.height * 0.3,
                                                                                                      child: Expanded(
                                                                                                        child: Text("If you change your mind, you'll have to request to follow ${data[index].name} again."),
                                                                                                      )),
                                                                                                  ElevatedButton(
                                                                                                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 238, 96, 143), fixedSize: Size(media.size.height * 0.1 * 1.5, media.size.height * 0.02)),
                                                                                                      onPressed: () {
                                                                                                        Provider.of<UserProvider>(context, listen: false).UnFollowuser(data[index], user);
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      child: Text(
                                                                                                        'UnFollow',
                                                                                                        style: TextStyle(color: Color.fromARGB(223, 12, 8, 19), fontSize: media.size.height * 0.02),
                                                                                                      )),
                                                                                                  ElevatedButton(
                                                                                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, fixedSize: Size(media.size.height * 0.1 * 1.5, media.size.height * 0.02)),
                                                                                                      onPressed: () {
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      child: Text(
                                                                                                        'Cancel',
                                                                                                        style: TextStyle(color: Color.fromARGB(223, 12, 8, 19), fontSize: media.size.height * 0.02),
                                                                                                      ))
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        });
                                                                                ;
                                                                              },
                                                                              child: Text(
                                                                                user.followings.contains(data[index].userid) ? 'Following' : 'Follow',
                                                                                style: TextStyle(color: Color.fromARGB(223, 12, 8, 19), fontSize: media.size.height * 0.02),
                                                                              ),
                                                                            ),
                                                                          )
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                      }
                                                      return Text('');
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
                                              icon: Icon(Icons.cancel_outlined),
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
                                    color: Color.fromARGB(223, 12, 8, 19),
                                    fontFamily: 'MyFont',
                                    fontSize: media.size.height * 0.02),
                              ),
                            ),
                            Text(
                              '${usermodel.followers.length}',
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            height:
                                                media.size.height * 0.4 * 1.3,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Followings',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        media.size.height *
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
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .where('userId',
                                                            whereIn: usermodel
                                                                .followings)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!.docs
                                                            .map((e) => Usermodel
                                                                .frommap(
                                                                    e.data()))
                                                            .toList();

                                                        return ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                data.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: media
                                                                            .size
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
                                                                              data[index].image),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            Text(
                                                                          data[index]
                                                                              .name,
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: 'MyFont',
                                                                              fontSize: media.size.height * 0.02,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    data[index].userid ==
                                                                            user
                                                                                .userid
                                                                        ? Text(
                                                                            '')
                                                                        : ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 238, 96, 143), fixedSize: Size(media.size.height * 0.1 * 1.5, media.size.height * 0.02)),
                                                                            onPressed:
                                                                                () {
                                                                              !user.followings.contains(data[index].userid)
                                                                                  ? Provider.of<UserProvider>(context, listen: false).followuser(data[index], user)
                                                                                  : showDialog(
                                                                                      context: context,
                                                                                      builder: (context) {
                                                                                        return Dialog(
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.symmetric(
                                                                                              horizontal: 20,
                                                                                            ),
                                                                                            height: media.size.height * 0.3,
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  height: media.size.height * 0.02,
                                                                                                ),
                                                                                                CircleAvatar(
                                                                                                  radius: media.size.height * 0.05,
                                                                                                  backgroundImage: NetworkImage(usermodel.image),
                                                                                                ),
                                                                                                Container(
                                                                                                    width: media.size.height * 0.3,
                                                                                                    child: Expanded(
                                                                                                      child: Text("If you change your mind, you'll have to request to follow ${usermodel.name} again."),
                                                                                                    )),
                                                                                                ElevatedButton(
                                                                                                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 238, 96, 143), fixedSize: Size(media.size.height * 0.1 * 1.5, media.size.height * 0.02)),
                                                                                                    onPressed: () {
                                                                                                      Provider.of<UserProvider>(context, listen: false).UnFollowuser(usermodel, user);
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Text(
                                                                                                      'UnFollow',
                                                                                                      style: TextStyle(color: Color.fromARGB(223, 12, 8, 19), fontSize: media.size.height * 0.02),
                                                                                                    )),
                                                                                                ElevatedButton(
                                                                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, fixedSize: Size(media.size.height * 0.1 * 1.5, media.size.height * 0.02)),
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Text(
                                                                                                      'Cancel',
                                                                                                      style: TextStyle(color: Color.fromARGB(223, 12, 8, 19), fontSize: media.size.height * 0.02),
                                                                                                    ))
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              user.followings.contains(data[index].userid)
                                                                                  ? 'Following'
                                                                                  : data[index].requested.contains(user.userid)
                                                                                      ? 'Requested'
                                                                                      : 'Follow',
                                                                              style: TextStyle(color: Color.fromARGB(223, 12, 8, 19), fontSize: media.size.height * 0.02),
                                                                            ),
                                                                          )
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                      }
                                                      return Text('');
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
                                              icon: Icon(Icons.cancel_outlined),
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
                                    color: Color.fromARGB(223, 12, 8, 19),
                                    fontFamily: 'MyFont',
                                    fontSize: media.size.height * 0.02),
                              ),
                            ),
                            Text(
                              '${usermodel.followings.length}',
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
                                  color: Color.fromARGB(223, 12, 8, 19),
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
                                  return Text('');
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

                //  MyData(value1: value1, value2: value2, value3: value3),
              ]);
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
