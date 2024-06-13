import 'dart:developer';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/commentmodel.dart';
import 'package:social_app/commentscreen.dart';
import 'package:social_app/editprofile.dart';
import 'package:social_app/likescontainer.dart';
import 'package:social_app/myprofile.dart';
import 'package:social_app/notificationmodel.dart';
import 'package:social_app/postmodel.dart';
import 'package:social_app/postprovider.dart';
import 'package:social_app/saveicon.dart';
import 'package:social_app/sharepref.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';
import 'package:uuid/uuid.dart';

class PostScreen extends StatelessWidget {
  PostScreen(
      {super.key,
      required this.post,
      required this.userId,
      required this.user});
  Postmodel post;
  String userId;
  Usermodel user;

  TextEditingController comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Color.fromARGB(223, 12, 8, 19),
        body: Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.data();
                    Usermodel model = Usermodel.frommap(data!);
                    return Column(
                      children: [
                        SizedBox(
                          height: media.size.height * 0.08,
                        ),
                        ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color.fromARGB(255, 238, 96, 143),
                                    width: media.size.height * 0.001)),
                            child: CircleAvatar(
                              radius: media.size.height * 0.04,
                              backgroundImage: NetworkImage(model.image),
                            ),
                          ),
                          title: Text(
                            model.name,
                            style: TextStyle(
                                color: Color.fromARGB(255, 200, 187, 187),
                                fontFamily: 'regular',
                                fontSize: media.size.height * 0.02 * 1.2),
                          ),
                          trailing: post.userId == user.userid
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 238, 96, 143),
                                      fixedSize: Size(
                                          media.size.height * 0.1 * 1.5,
                                          media.size.height * 0.02)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfile(value: false)));
                                  },
                                  child: Text(
                                    'EditProfile',
                                    style: TextStyle(
                                        color: Color.fromARGB(223, 12, 8, 19),
                                        fontSize: media.size.height * 0.02),
                                  ))
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 238, 96, 143),
                                      fixedSize: Size(
                                          media.size.height * 0.1 * 1.6,
                                          media.size.height * 0.02)),
                                  onPressed: () {
                                    model.followers.contains(user.userid)
                                        ? showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                  ),
                                                  height:
                                                      media.size.height * 0.3,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            media.size.height *
                                                                0.02,
                                                      ),
                                                      CircleAvatar(
                                                        radius:
                                                            media.size.height *
                                                                0.05,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                model.image),
                                                      ),
                                                      Container(
                                                          width: media
                                                                  .size.height *
                                                              0.3,
                                                          child: Expanded(
                                                            child: Text(
                                                                "If you change your mind, you'll have to request to follow ${model.name} again."),
                                                          )),
                                                      ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          238,
                                                                          96,
                                                                          143),
                                                              fixedSize: Size(
                                                                  media.size
                                                                          .height *
                                                                      0.1 *
                                                                      1.5,
                                                                  media.size
                                                                          .height *
                                                                      0.02)),
                                                          onPressed: () {
                                                            Provider.of<UserProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .UnfollowPostuser(
                                                                    model,
                                                                    user);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'UnFollow',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        223,
                                                                        12,
                                                                        8,
                                                                        19),
                                                                fontSize: media
                                                                        .size
                                                                        .height *
                                                                    0.02),
                                                          )),
                                                      ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              fixedSize: Size(
                                                                  media.size
                                                                          .height *
                                                                      0.1 *
                                                                      1.5,
                                                                  media.size
                                                                          .height *
                                                                      0.02)),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        223,
                                                                        12,
                                                                        8,
                                                                        19),
                                                                fontSize: media
                                                                        .size
                                                                        .height *
                                                                    0.02),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })
                                        : Provider.of<UserProvider>(context,
                                                listen: false)
                                            .followPostuser(model, user);
                                  },
                                  child: Center(
                                    child: Text(
                                      model.followers.contains(user.userid)
                                          ? 'Following'
                                          : model.requested
                                                  .contains(user.userid)
                                              ? 'Requested'
                                              : 'Follow',
                                      style: TextStyle(
                                          color: Color.fromARGB(223, 12, 8, 19),
                                          fontSize: media.size.height * 0.02),
                                    ),
                                  )),
                        ),
                        SizedBox(
                          height: media.size.height * 0.04,
                        ),
                        post.posttype == postType.image
                            ? Container(
                                width: media.size.height * 1,
                                height: media.size.height * 0.5 * 1.1,
                                child: Image.network(
                                  post.post,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : PostScreenPlayer(
                                videoplayer: post.post,
                              ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: media.size.height * 0.01),
                          child: Row(
                            children: [
                              SizedBox(
                                width: media.size.height * 0.02,
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<PostProvider>(context,
                                          listen: false)
                                      .likepost(post.postId, user);
                                },
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Post')
                                        .doc(post.postId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var data = snapshot.data!.data();
                                        Postmodel post =
                                            Postmodel.frommap(data!);
                                        return Icon(
                                          post.likes.contains(user.userid)
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: Colors.white,
                                          size: media.size.height * 0.03 * 1.3,
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    }),
                              ),
                              SizedBox(
                                width: media.size.height * 0.02,
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      enableDrag: true,
                                      elevation: 0,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25))),
                                      useSafeArea: false,
                                      context: context,
                                      backgroundColor: Colors.pink,
                                      builder: (context) => CommentScreen(
                                          userimage: user.image,
                                          username: user.name,
                                          postId: post.postId,
                                          userId: user.userid));
                                },
                                child: Icon(
                                  Icons.comment,
                                  color: Colors.white,
                                  size: media.size.height * 0.03 * 1.3,
                                ),
                              ),
                              SizedBox(
                                width: media.size.height * 0.2 * 1.3,
                              ),

                              // SavePost(
                              //   postId: widget.post.postId,
                              // )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: media.size.height * 0.01,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: media.size.height * 0.02),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => Likescontainer(
                                        likes: post.likes,
                                        user: user,
                                      ));
                            },
                            child: Row(
                              children: [
                                Consumer<PostProvider>(
                                    builder: (context, pro, _) {
                                  int index = pro.allposts.indexWhere(
                                      (element) =>
                                          element.postId == post.postId);
                                  Postmodel posto = pro.allposts[index];
                                  return Text(
                                    '${posto.likes.length}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: media.size.height * 0.02),
                                  );
                                }),
                                SizedBox(width: media.size.height * 0.01),
                                Text(
                                  'likes',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: media.size.height * 0.02),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: media.size.height * 0.02),
                          child: Row(
                            children: [
                              Text(
                                post.caption,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: media.size.height * 0.02),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: media.size.height * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                enableDrag: true,
                                elevation: 0,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25))),
                                useSafeArea: false,
                                context: context,
                                backgroundColor: Colors.pink,
                                builder: (context) => CommentScreen(
                                    userimage: user.image,
                                    username: user.name,
                                    postId: post.postId,
                                    userId: user.userid));
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: media.size.height * 0.02),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'View all Comments',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 200, 187, 187)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.size.height * 0.02,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: media.size.height * 0.02,
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var data = snapshot.data!.data();

                                    return CircleAvatar(
                                      backgroundImage:
                                          NetworkImage('${data!['image']}'),
                                      radius: media.size.height * 0.03,
                                    );
                                  }
                                  return CircularProgressIndicator();
                                }),
                            SizedBox(
                              width: media.size.height * 0.01,
                            ),
                            SizedBox(
                                width: media.size.height * 0.3,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: comment,
                                  decoration: InputDecoration(
                                    hintText: 'Add Comment...',
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 200, 187, 187)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 200, 187, 187))),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 200, 187, 187))),
                                  ),
                                )),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Post')
                                    .doc(post.postId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(
                                            media.size.height * 0.03,
                                            media.size.height * 0.07),
                                        shape: CircleBorder(),
                                        backgroundColor:
                                            Color.fromARGB(255, 238, 96, 143),
                                      ),
                                      onPressed: () async {
                                        if (comment.text.isNotEmpty) {
                                          String commentId = Uuid().v4();
                                          Commentmodel model = Commentmodel(
                                              likes: [],
                                              comment: comment.text,
                                              commentId: commentId,
                                              postId: post.postId,
                                              userId: user.userid);
                                          await FirebaseFirestore.instance
                                              .collection('Post')
                                              .doc(post.postId)
                                              .collection('comments')
                                              .doc(commentId)
                                              .set(model.toMap());
                                          String Id = Uuid().v4();
                                          NotificationModel notmodel =
                                              NotificationModel(
                                                  commentId: model.commentId,
                                                  postId: model.postId,
                                                  currentuser: user.userid,
                                                  notificationId: Id,
                                                  notification: model.comment,
                                                  otheruser: post.userId,
                                                  time: DateTime.now());

                                          await FirebaseFirestore.instance
                                              .collection('notifications')
                                              .doc(Id)
                                              .set(notmodel.tomap());

                                          comment.clear();
                                        }
                                      },
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ));
                                })
                          ],
                        )
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                })));
  }
}

class PostScreenPlayer extends StatefulWidget {
  PostScreenPlayer({super.key, required this.videoplayer});
  String videoplayer;

  @override
  State<PostScreenPlayer> createState() => _PostScreenPlayerState();
}

class _PostScreenPlayerState extends State<PostScreenPlayer> {
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
        width: media.size.height * 1,
        height: media.size.height * 0.5 * 1.1,
        child: CachedVideoPlayerPlus(videocontroller));
  }
}
