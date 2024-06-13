import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_app/commentmodel.dart';
import 'package:social_app/notificationmodel.dart';
import 'package:social_app/postprovider.dart';
import 'package:social_app/repliescommentmodel.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';
import 'package:uuid/uuid.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({
    super.key,
    required this.postId,
    required this.userId,
    required this.userimage,
    required this.username,
  });
  String postId;
  String userId;
  String userimage;
  String username;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool reply = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Container(
        height: media.size.height * 0.6 * 1.1,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
            // color: Color.fromARGB(223, 12, 8, 19).withOpacity(0.4),
            color: Colors.pink.withOpacity(0.7),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),

        // color: Color.fromARGB(223, 12, 8, 19).withOpacity(0.2),
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: media.size.height * 0.05,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Post')
                    .doc(widget.postId)
                    .collection('comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: media.size.height * 0.5,
                      child: snapshot.data!.docs.length == 0
                          ? Center(
                              child: Text(
                              'there is not comment yet here',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'MyFont',
                                  fontSize: media.size.height * 0.02),
                            ))
                          : ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index].data();
                                Commentmodel model = Commentmodel.fromMap(data);
                                return CommentContainer(
                                  username: widget.username,
                                  comment: model.comment,
                                  userimage: widget.userimage,
                                  commentId: model.commentId,
                                  postId: widget.postId,
                                  userId: widget.userId,
                                );
                              }),
                    );
                  } else {
                    return Text('data');
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class CommentContainer extends StatefulWidget {
  CommentContainer({
    super.key,
    required this.comment,
    required this.postId,
    required this.commentId,
    required this.userId,
    required this.userimage,
    required this.username,
  });
  String comment;
  String postId;
  String commentId;
  String userId;
  String userimage;
  String username;

  @override
  State<CommentContainer> createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer> {
  bool reply = false;
  bool post = false;
  bool viewreply = false;
  TextEditingController replycomment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<UserProvider>(context).user;
    var media = MediaQuery.of(context);
    return reply == true && post == false
        ? Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(widget.userimage),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 1),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(223, 12, 8, 19),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.username,
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontFamily: 'MyFont',
                                    fontSize: media.size.height * 0.02 * 1.1),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<PostProvider>(context,
                                          listen: false)
                                      .likecomment(widget.commentId, prov!,
                                          widget.postId);
                                },
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Post')
                                        .doc(widget.postId)
                                        .collection('comments')
                                        .doc(widget.commentId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var data = snapshot.data!.data();
                                        Commentmodel comment =
                                            Commentmodel.fromMap(data!);
                                        return Icon(
                                          comment.likes.contains(prov!.userid)
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: Colors.pink,
                                          size: media.size.height * 0.02 * 1.1,
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    }),

                                // Icon(
                                //   Icons.favorite_border,
                                //   color: Colors.pink,
                                //   size: media.size.height * 0.02 * 1.1,
                                // ),
                              )
                            ],
                          ),
                          Text(
                            widget.comment,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: () {
                      reply = true;
                      setState(() {});
                    },
                    child: Text(
                      'reply',
                      style: TextStyle(
                        fontFamily: 'MyFont',
                        color: Color.fromARGB(223, 12, 8, 19),
                      ),
                    )),
              ),
              TextFormField(
                style: TextStyle(color: Color.fromARGB(223, 12, 8, 19)),
                controller: replycomment,
                decoration: InputDecoration(
                    hintText: 'Add reply...',
                    hintStyle: TextStyle(color: Color.fromARGB(223, 12, 8, 19)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: media.size.height * 0.001,
                          color: Color.fromARGB(223, 12, 8, 19),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: media.size.height * 0.001,
                          color: Color.fromARGB(223, 12, 8, 19),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              InkWell(
                onTap: () async {
                  if (replycomment.text.isNotEmpty) {
                    String replycommentId = Uuid().v4();
                    ReplyComments model = ReplyComments(
                        replyId: replycommentId,
                        likes: [],
                        commentId: widget.commentId,
                        postId: widget.postId,
                        replycomment: replycomment.text,
                        userId: widget.userId);
                    await FirebaseFirestore.instance
                        .collection('Post')
                        .doc(widget.postId)
                        .collection('comments')
                        .doc(widget.commentId)
                        .collection('replycomments')
                        .doc(replycommentId)
                        .set(model.toMap());
                    String Id = Uuid().v4();
                    NotificationModel notmodel = NotificationModel(
                        commentId: model.replyId,
                        postId: model.postId,
                        currentuser: widget.userId,
                        notificationId: Id,
                        notification: 'like your comment',
                        otheruser: model.userId,
                        time: DateTime.now());
                    if (widget.userId != model.userId) {
                      await FirebaseFirestore.instance
                          .collection('notifications')
                          .doc(Id)
                          .set(notmodel.tomap());
                    }
                    replycomment.clear();

                    setState(() {
                      reply = false;
                      post = true;
                    });
                  }
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Post',
                    style: TextStyle(
                        fontSize: media.size.height * 0.02,
                        color: Color.fromARGB(223, 12, 8, 19),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
        : Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(widget.userimage),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 1),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(223, 12, 8, 19),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.username,
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontFamily: 'MyFont',
                                    fontSize: media.size.height * 0.02 * 1.1),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<PostProvider>(context,
                                          listen: false)
                                      .likecomment(widget.commentId, prov!,
                                          widget.postId);
                                },
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Post')
                                        .doc(widget.postId)
                                        .collection('comments')
                                        .doc(widget.commentId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var data = snapshot.data!.data();
                                        Commentmodel comment =
                                            Commentmodel.fromMap(data!);
                                        return Icon(
                                          comment.likes.contains(prov!.userid)
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: Colors.pink,
                                          size: media.size.height * 0.02 * 1.1,
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    }),
                              )
                            ],
                          ),
                          Text(
                            widget.comment,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              viewreply
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: media.size.height * 0.1 * 1.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  viewreply = false;
                                  setState(() {});
                                },
                                child: Text(
                                  '_Hide replies',
                                  style: TextStyle(
                                    fontFamily: 'MyFont',
                                    color: Color.fromARGB(223, 12, 8, 19),
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    reply = true;
                                    setState(() {});
                                  },
                                  child: Text(
                                    'reply',
                                    style: TextStyle(
                                      fontFamily: 'MyFont',
                                      color: Color.fromARGB(223, 12, 8, 19),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Post')
                                .doc(widget.postId)
                                .collection('comments')
                                .doc(widget.commentId)
                                .collection('replycomments')
                                .snapshots(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  height: media.size.height * 1,
                                  width: media.size.height * 1,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var data =
                                            snapshot.data!.docs[index].data();
                                        ReplyComments replymodel =
                                            ReplyComments.fromMap(data);
                                        return ReplyCommentContainer(
                                          commentId: widget.commentId,
                                          replycommentId: replymodel.replyId,
                                          postId: widget.postId,
                                          userimage: widget.userimage,
                                          username: widget.username,
                                          replycomment: replymodel.replycomment,
                                        );
                                      }),
                                );
                              }
                              return CircularProgressIndicator();
                            })),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: media.size.height * 0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              viewreply = true;
                              setState(() {});
                            },
                            child: Text(
                              '_View replies',
                              style: TextStyle(
                                fontFamily: 'MyFont',
                                color: Color.fromARGB(223, 12, 8, 19),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                reply = true;
                                setState(() {});
                              },
                              child: Text(
                                'reply',
                                style: TextStyle(
                                  fontFamily: 'MyFont',
                                  color: Color.fromARGB(223, 12, 8, 19),
                                ),
                              )),
                        ],
                      ),
                    )
            ],
          );
  }
}
//  InkWell(
//       onTap: () async {
//         if (replycomment.text.isNotEmpty) {
//           String replycommentId = Uuid().v4();
//           ReplyComments model = ReplyComments(
//               commentId: widget.commentId,
//               postId: widget.postId,
//               replycomment: replycomment.text,
//               userId: widget.userId);
//           await FirebaseFirestore.instance
//               .collection('Post')
//               .doc(widget.postId)
//               .collection('comments')
//               .doc(widget.commentId)
//               .collection('replycomments')
//               .doc(replycommentId)
//               .set(model.toMap());

//           replycomment.clear();
//         }
//       },
//       child: Icon(
//         Icons.send,
//       ),
//     )
//   ],
// ),
// TextFormField(
//   controller: replycomment,
// )

class ReplyCommentContainer extends StatelessWidget {
  ReplyCommentContainer(
      {super.key,
      required this.replycomment,
      required this.userimage,
      required this.commentId,
      required this.postId,
      required this.replycommentId,
      required this.username});
  String userimage;
  String username;
  String replycomment;
  String replycommentId;
  String commentId;

  String postId;

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<UserProvider>(context).user;
    var media = MediaQuery.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(userimage),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 1),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(223, 12, 8, 19),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                          color: Colors.pink,
                          fontFamily: 'MyFont',
                          fontSize: media.size.height * 0.02 * 1.1),
                    ),
                    InkWell(
                      onTap: () {
                        Provider.of<PostProvider>(context, listen: false)
                            .likecommentreply(
                                replycommentId, commentId, prov!, postId);
                      },
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Post')
                              .doc(postId)
                              .collection('comments')
                              .doc(commentId)
                              .collection('replycomments')
                              .doc(replycommentId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.data();
                              ReplyComments replycomments =
                                  ReplyComments.fromMap(data!);
                              return Icon(
                                replycomments.likes.contains(prov!.userid)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color: Colors.pink,
                                size: media.size.height * 0.02 * 1.1,
                              );
                            }
                            return CircularProgressIndicator();
                          }),
                    )
                  ],
                ),
                Text(
                  replycomment,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    ;
  }
}
