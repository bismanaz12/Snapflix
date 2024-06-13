import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_app/commentmodel.dart';
import 'package:social_app/commentscreen.dart';
import 'package:social_app/drawer.dart';
import 'package:social_app/likescontainer.dart';
import 'package:social_app/login.dart';
import 'package:social_app/myprofile.dart';
import 'package:social_app/notificationmodel.dart';
import 'package:social_app/notificationsscreen.dart';
import 'package:social_app/otheruserprofile.dart';
import 'package:social_app/postcontainer.dart';
import 'package:social_app/postmodel.dart';
import 'package:social_app/postprovider.dart';
import 'package:social_app/postscreen.dart';
import 'package:social_app/saveicon.dart';
import 'package:social_app/sharepref.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getUsers();
    Provider.of<PostProvider>(context, listen: false).getCureentuserPost();
    Provider.of<UserProvider>(context, listen: false).getallUsers();
    Provider.of<PostProvider>(context, listen: false).getallpost();

    super.initState();
  }

  bool saved = false;
  TextEditingController imagecomment = TextEditingController();
  TextEditingController videocomment = TextEditingController();
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<UserProvider>(context).user;

    var media = MediaQuery.of(context);

    return prov == null
        ? CircularProgressIndicator()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: CustomDrawer(),
            backgroundColor: Color.fromARGB(223, 12, 8, 19),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(235, 29, 29, 58),
              leading: Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Color.fromARGB(255, 238, 96, 143),
                    size: media.size.height * 0.03,
                  ),
                );
              }),
              title: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('otheruser',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: snapshot.data!.docs.length > 0
                            ? Stack(children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationsScreen(
                                                  user: prov,
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.notifications_outlined,
                                    color: Color.fromARGB(255, 200, 187, 187),
                                    size: media.size.height * 0.03 * 1.2,
                                  ),
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.red,
                                )
                              ])
                            : InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationsScreen(
                                                user: prov,
                                              )));
                                },
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: Color.fromARGB(255, 200, 187, 187),
                                  size: media.size.height * 0.03 * 1.2,
                                ),
                              ),
                      );
                    }
                    return Text('');
                  }),
            ),
            body: Container(
              height: double.infinity,
              child: Column(children: [
                SizedBox(
                  height: media.size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: media.size.height * 0.03,
                      right: media.size.height * 0.03),
                  child: SearchBar(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      side: BorderSide(
                          color: Color.fromARGB(255, 200, 187, 187),
                          width: media.size.height * 0.001),
                    )),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    leading: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 200, 187, 187),
                    ),
                    hintText: 'search for...',
                    hintStyle: MaterialStatePropertyAll(
                        TextStyle(color: Color.fromARGB(255, 200, 187, 187))),
                    onChanged: (value) {
                      search.text = value;
                    },
                    controller: search,
                    textStyle: MaterialStatePropertyAll(
                        TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: media.size.height * 0.04,
                ),
                Consumer<PostProvider>(builder: (context, pro, _) {
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: pro.allposts.length,
                        itemBuilder: (context, index) {
                          var data = pro.allposts[index].caption.toString();
                          if (pro.allposts[index].posttype == postType.video) {
                            if (search.text.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: media.size.height * 0.02,
                                    left: media.size.height * 0.02,
                                    right: media.size.height * 0.02),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(235, 29, 29, 58),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  height: media.size.height * 0.1 * 6.6,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02,
                                            top: media.size.height * 0.02),
                                        child: Row(
                                          children: [
                                            StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(pro
                                                        .allposts[index].userId)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    var data =
                                                        snapshot.data!.data();
                                                    Usermodel users =
                                                        Usermodel.frommap(
                                                            data!);
                                                    String otheruserId = pro
                                                        .allposts[index].userId;
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => pro
                                                                            .allposts[
                                                                                index]
                                                                            .userId ==
                                                                        prov
                                                                            .userid
                                                                    ? MyProfile(
                                                                        value:
                                                                            false)
                                                                    : OtherUserProfile(
                                                                        otheruserId:
                                                                            otheruserId,
                                                                        otheruser:
                                                                            users)));
                                                      },
                                                      child: CircleAvatar(
                                                        radius:
                                                            media.size.height *
                                                                0.03,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                data!['image']),
                                                      ),
                                                    );
                                                  }
                                                  return CircularProgressIndicator();
                                                }),
                                            SizedBox(
                                              width: media.size.height * 0.02,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(pro.allposts[index]
                                                            .userId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        return Text(
                                                          '${data!['username']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'MyFont',
                                                              fontSize: media
                                                                      .size
                                                                      .height *
                                                                  0.02 *
                                                                  1.1),
                                                        );
                                                      }
                                                      return CircularProgressIndicator();
                                                    }),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${DateFormat('h').format(pro.allposts[index].time)}',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              200,
                                                              187,
                                                              187),
                                                          fontSize: media
                                                                  .size.height *
                                                              0.02),
                                                    ),
                                                    Text(
                                                      ' hour ago',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              200,
                                                              187,
                                                              187),
                                                          fontSize: media
                                                                  .size.height *
                                                              0.02),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width:
                                                  media.size.height * 0.1 * 1.5,
                                            ),
                                            pro.allposts[index].userId !=
                                                    prov.userid
                                                ? StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(pro.allposts[index]
                                                            .userId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        Usermodel usermodel =
                                                            Usermodel.frommap(
                                                                data!);

                                                        return PopupMenuButton(
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'Block') {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                          ),
                                                                          height:
                                                                              media.size.height * 0.3,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
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
                                                                                    Provider.of<UserProvider>(context, listen: false).BlockUser(usermodel, prov);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'Block',
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
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PostScreen(
                                                                            post:
                                                                                pro.allposts[index],
                                                                            userId: pro.allposts[index].userId,
                                                                            user: prov)));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            itemBuilder:
                                                                (context) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child: Text(usermodel
                                                                          .blockBy
                                                                          .contains(
                                                                              prov.userid)
                                                                      ? 'Unblock'
                                                                      : 'Block'),
                                                                  value:
                                                                      'Block',
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'View Post'),
                                                                  value:
                                                                      'View Post',
                                                                ),
                                                              ];
                                                            });
                                                      }
                                                      return Text('');
                                                    })
                                                : StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(prov.userid)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        Usermodel usermodel =
                                                            Usermodel.frommap(
                                                                data!);

                                                        return PopupMenuButton(
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'Delete') {
                                                                Provider.of<PostProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .deletePost(pro
                                                                        .allposts[
                                                                            index]
                                                                        .postId);
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PostScreen(
                                                                            post:
                                                                                pro.allposts[index],
                                                                            userId: pro.allposts[index].userId,
                                                                            user: prov)));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            itemBuilder:
                                                                (context) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'Delete'),
                                                                  value:
                                                                      'Delete',
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'View Post'),
                                                                  value:
                                                                      'View Post',
                                                                ),
                                                              ];
                                                            });
                                                      }
                                                      return Text('');
                                                    })
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.02,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostScreen(
                                                        user: prov,
                                                        post:
                                                            pro.allposts[index],
                                                        userId: pro
                                                            .allposts[index]
                                                            .userId,
                                                      )));
                                        },
                                        child: Container(
                                            height: media.size.height * 0.3,
                                            width:
                                                media.size.height * 0.3 * 1.3,
                                            child: PostPlayer(
                                                videoplayer:
                                                    pro.allposts[index].post)),
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: media.size.height * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<PostProvider>(context,
                                                      listen: false)
                                                  .likepost(
                                                      pro.allposts[index]
                                                          .postId,
                                                      prov);
                                            },
                                            child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('Post')
                                                    .doc(pro
                                                        .allposts[index].postId)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    var data =
                                                        snapshot.data!.data();
                                                    Postmodel post =
                                                        Postmodel.frommap(
                                                            data!);
                                                    return Icon(
                                                      post.likes.contains(
                                                              prov.userid)
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_outline,
                                                      color: Colors.white,
                                                      size: media.size.height *
                                                          0.03 *
                                                          1.2,
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
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      25))),
                                                  useSafeArea: false,
                                                  context: context,
                                                  backgroundColor: Colors.pink,
                                                  builder: (context) =>
                                                      CommentScreen(
                                                          userimage: prov.image,
                                                          username: prov.name,
                                                          postId: pro
                                                              .allposts[index]
                                                              .postId,
                                                          userId: prov.userid));
                                            },
                                            child: Icon(
                                              Icons.comment,
                                              color: Colors.white,
                                              size: media.size.height *
                                                  0.03 *
                                                  1.2,
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                media.size.height * 0.2 * 1.2,
                                          ),
                                          SavePost(
                                              postId:
                                                  pro.allposts[index].postId),
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.01,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02),
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    Likescontainer(
                                                      likes: pro.allposts[index]
                                                          .likes,
                                                      user: prov,
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                '${pro.allposts[index].likes.length}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        media.size.height *
                                                            0.02),
                                              ),
                                              SizedBox(
                                                  width:
                                                      media.size.height * 0.01),
                                              Text(
                                                'likes',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        media.size.height *
                                                            0.02),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02),
                                        child: Row(
                                          children: [
                                            Text(
                                              pro.allposts[index].caption,
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              25))),
                                              useSafeArea: false,
                                              context: context,
                                              backgroundColor: Colors.pink,
                                              builder: (context) =>
                                                  CommentScreen(
                                                      userimage: prov.image,
                                                      username: prov.name,
                                                      postId: pro
                                                          .allposts[index]
                                                          .postId,
                                                      userId: prov.userid));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: media.size.height * 0.02),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'View all Comments',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 200, 187, 187)),
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
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  var data =
                                                      snapshot.data!.data();

                                                  return CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            '${data!['image']}'),
                                                    radius: media.size.height *
                                                        0.03,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                                controller: videocomment,
                                                decoration: InputDecoration(
                                                  hintText: 'Add Comment...',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 200, 187, 187)),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      200,
                                                                      187,
                                                                      187))),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      200,
                                                                      187,
                                                                      187))),
                                                ),
                                              )),
                                          StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Post')
                                                  .doc(pro
                                                      .allposts[index].postId)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                return InkWell(
                                                    onTap: () async {
                                                      if (videocomment
                                                          .text.isNotEmpty) {
                                                        String commentId =
                                                            Uuid().v4();
                                                        Commentmodel model =
                                                            Commentmodel(
                                                                likes: [],
                                                                comment:
                                                                    videocomment
                                                                        .text,
                                                                commentId:
                                                                    commentId,
                                                                postId: pro
                                                                    .allposts[
                                                                        index]
                                                                    .postId,
                                                                userId: prov
                                                                    .userid);
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('Post')
                                                            .doc(pro
                                                                .allposts[index]
                                                                .postId)
                                                            .collection(
                                                                'comments')
                                                            .doc(commentId)
                                                            .set(model.toMap());
                                                        String Id = Uuid().v4();
                                                        NotificationModel
                                                            notmodel =
                                                            NotificationModel(
                                                                commentId: model
                                                                    .commentId,
                                                                postId: model
                                                                    .postId,
                                                                currentuser:
                                                                    prov.userid,
                                                                notificationId:
                                                                    Id,
                                                                notification:
                                                                    model
                                                                        .comment,
                                                                otheruser: pro
                                                                    .allposts[
                                                                        index]
                                                                    .userId,
                                                                time: DateTime
                                                                    .now());

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'notifications')
                                                            .doc(Id)
                                                            .set(notmodel
                                                                .tomap());

                                                        videocomment.clear();
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
                                  ),
                                ),
                              );
                            } else if (data
                                .toLowerCase()
                                .contains(search.text.toLowerCase())) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: media.size.height * 0.02,
                                    left: media.size.height * 0.02,
                                    right: media.size.height * 0.02),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(235, 29, 29, 58),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  height: media.size.height * 0.1 * 6.6,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02,
                                            top: media.size.height * 0.02),
                                        child: Row(
                                          children: [
                                            StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(pro
                                                        .allposts[index].userId)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    var data =
                                                        snapshot.data!.data();
                                                    Usermodel users =
                                                        Usermodel.frommap(
                                                            data!);
                                                    String otheruserId = pro
                                                        .allposts[index].userId;
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => pro
                                                                            .allposts[
                                                                                index]
                                                                            .userId ==
                                                                        prov
                                                                            .userid
                                                                    ? MyProfile(
                                                                        value:
                                                                            false)
                                                                    : OtherUserProfile(
                                                                        otheruserId:
                                                                            otheruserId,
                                                                        otheruser:
                                                                            users)));
                                                      },
                                                      child: CircleAvatar(
                                                        radius:
                                                            media.size.height *
                                                                0.03,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                data!['image']),
                                                      ),
                                                    );
                                                  }
                                                  return CircularProgressIndicator();
                                                }),
                                            SizedBox(
                                              width: media.size.height * 0.02,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(pro.allposts[index]
                                                            .userId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        return Text(
                                                          '${data!['username']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'MyFont',
                                                              fontSize: media
                                                                      .size
                                                                      .height *
                                                                  0.02 *
                                                                  1.1),
                                                        );
                                                      }
                                                      return CircularProgressIndicator();
                                                    }),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${DateFormat('h').format(pro.allposts[index].time)}',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              200,
                                                              187,
                                                              187),
                                                          fontSize: media
                                                                  .size.height *
                                                              0.02),
                                                    ),
                                                    Text(
                                                      ' hour ago',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              200,
                                                              187,
                                                              187),
                                                          fontSize: media
                                                                  .size.height *
                                                              0.02),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width:
                                                  media.size.height * 0.1 * 1.5,
                                            ),
                                            pro.allposts[index].userId !=
                                                    prov.userid
                                                ? StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(pro.allposts[index]
                                                            .userId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        Usermodel usermodel =
                                                            Usermodel.frommap(
                                                                data!);

                                                        return PopupMenuButton(
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'Block') {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                          ),
                                                                          height:
                                                                              media.size.height * 0.3,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
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
                                                                                    Provider.of<UserProvider>(context, listen: false).BlockUser(usermodel, prov);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'Block',
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
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PostScreen(
                                                                            post:
                                                                                pro.allposts[index],
                                                                            userId: pro.allposts[index].userId,
                                                                            user: prov)));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            itemBuilder:
                                                                (context) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child: Text(usermodel
                                                                          .blockBy
                                                                          .contains(
                                                                              prov.userid)
                                                                      ? 'Unblock'
                                                                      : 'Block'),
                                                                  value:
                                                                      'Block',
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'View Post'),
                                                                  value:
                                                                      'View Post',
                                                                ),
                                                              ];
                                                            });
                                                      }
                                                      return Text('');
                                                    })
                                                : StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(prov.userid)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        Usermodel usermodel =
                                                            Usermodel.frommap(
                                                                data!);

                                                        return PopupMenuButton(
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'Delete') {
                                                                Provider.of<PostProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .deletePost(pro
                                                                        .allposts[
                                                                            index]
                                                                        .postId);
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PostScreen(
                                                                            post:
                                                                                pro.allposts[index],
                                                                            userId: pro.allposts[index].userId,
                                                                            user: prov)));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            itemBuilder:
                                                                (context) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'Delete'),
                                                                  value:
                                                                      'Delete',
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'View Post'),
                                                                  value:
                                                                      'View Post',
                                                                ),
                                                              ];
                                                            });
                                                      }
                                                      return Text('');
                                                    })
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.02,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostScreen(
                                                        user: prov,
                                                        post:
                                                            pro.allposts[index],
                                                        userId: pro
                                                            .allposts[index]
                                                            .userId,
                                                      )));
                                        },
                                        child: Container(
                                            height: media.size.height * 0.3,
                                            width:
                                                media.size.height * 0.3 * 1.3,
                                            child: PostPlayer(
                                                videoplayer:
                                                    pro.allposts[index].post)),
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: media.size.height * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<PostProvider>(context,
                                                      listen: false)
                                                  .likepost(
                                                      pro.allposts[index]
                                                          .postId,
                                                      prov);
                                            },
                                            child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('Post')
                                                    .doc(pro
                                                        .allposts[index].postId)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    var data =
                                                        snapshot.data!.data();
                                                    Postmodel post =
                                                        Postmodel.frommap(
                                                            data!);
                                                    return Icon(
                                                      post.likes.contains(
                                                              prov.userid)
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_outline,
                                                      color: Colors.white,
                                                      size: media.size.height *
                                                          0.03 *
                                                          1.2,
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
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      25))),
                                                  useSafeArea: false,
                                                  context: context,
                                                  backgroundColor: Colors.pink,
                                                  builder: (context) =>
                                                      CommentScreen(
                                                          userimage: prov.image,
                                                          username: prov.name,
                                                          postId: pro
                                                              .allposts[index]
                                                              .postId,
                                                          userId: prov.userid));
                                            },
                                            child: Icon(
                                              Icons.comment,
                                              color: Colors.white,
                                              size: media.size.height *
                                                  0.03 *
                                                  1.2,
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                media.size.height * 0.2 * 1.2,
                                          ),
                                          SavePost(
                                              postId:
                                                  pro.allposts[index].postId),
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.01,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02),
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    Likescontainer(
                                                      likes: pro.allposts[index]
                                                          .likes,
                                                      user: prov,
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                '${pro.allposts[index].likes.length}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        media.size.height *
                                                            0.02),
                                              ),
                                              SizedBox(
                                                  width:
                                                      media.size.height * 0.01),
                                              Text(
                                                'likes',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        media.size.height *
                                                            0.02),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02),
                                        child: Row(
                                          children: [
                                            Text(
                                              pro.allposts[index].caption,
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              25))),
                                              useSafeArea: false,
                                              context: context,
                                              backgroundColor: Colors.pink,
                                              builder: (context) =>
                                                  CommentScreen(
                                                      userimage: prov.image,
                                                      username: prov.name,
                                                      postId: pro
                                                          .allposts[index]
                                                          .postId,
                                                      userId: prov.userid));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: media.size.height * 0.02),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'View all Comments',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 200, 187, 187)),
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
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  var data =
                                                      snapshot.data!.data();

                                                  return CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            '${data!['image']}'),
                                                    radius: media.size.height *
                                                        0.03,
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                                controller: videocomment,
                                                decoration: InputDecoration(
                                                  hintText: 'Add Comment...',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 200, 187, 187)),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      200,
                                                                      187,
                                                                      187))),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      200,
                                                                      187,
                                                                      187))),
                                                ),
                                              )),
                                          StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Post')
                                                  .doc(pro
                                                      .allposts[index].postId)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                return InkWell(
                                                    onTap: () async {
                                                      if (videocomment
                                                          .text.isNotEmpty) {
                                                        String commentId =
                                                            Uuid().v4();
                                                        Commentmodel model =
                                                            Commentmodel(
                                                                likes: [],
                                                                comment:
                                                                    videocomment
                                                                        .text,
                                                                commentId:
                                                                    commentId,
                                                                postId: pro
                                                                    .allposts[
                                                                        index]
                                                                    .postId,
                                                                userId: prov
                                                                    .userid);
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('Post')
                                                            .doc(pro
                                                                .allposts[index]
                                                                .postId)
                                                            .collection(
                                                                'comments')
                                                            .doc(commentId)
                                                            .set(model.toMap());
                                                        String Id = Uuid().v4();
                                                        NotificationModel
                                                            notmodel =
                                                            NotificationModel(
                                                                commentId: model
                                                                    .commentId,
                                                                postId: model
                                                                    .postId,
                                                                currentuser:
                                                                    prov.userid,
                                                                notificationId:
                                                                    Id,
                                                                notification:
                                                                    model
                                                                        .comment,
                                                                otheruser: pro
                                                                    .allposts[
                                                                        index]
                                                                    .userId,
                                                                time: DateTime
                                                                    .now());

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'notifications')
                                                            .doc(Id)
                                                            .set(notmodel
                                                                .tomap());

                                                        videocomment.clear();
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
                                  ),
                                ),
                              );
                            } else {}
                          } else {
                            if (search.text.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: media.size.height * 0.02,
                                    left: media.size.height * 0.02,
                                    right: media.size.height * 0.02),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(235, 29, 29, 58),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  height: media.size.height * 0.1 * 6.6,
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: media.size.height * 0.02,
                                              top: media.size.height * 0.02),
                                          child: Row(children: [
                                            StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(pro
                                                        .allposts[index].userId)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    var data =
                                                        snapshot.data!.data();
                                                    Usermodel users =
                                                        Usermodel.frommap(
                                                            data!);
                                                    Usermodel.frommap(data);
                                                    String otheruserId = pro
                                                        .allposts[index].userId;
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => pro
                                                                            .allposts[
                                                                                index]
                                                                            .userId ==
                                                                        prov
                                                                            .userid
                                                                    ? MyProfile(
                                                                        value:
                                                                            false)
                                                                    : OtherUserProfile(
                                                                        otheruserId:
                                                                            otheruserId,
                                                                        otheruser:
                                                                            users)));
                                                      },
                                                      child: CircleAvatar(
                                                        radius:
                                                            media.size.height *
                                                                0.03,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                data['image']),
                                                      ),
                                                    );
                                                  }
                                                  return CircularProgressIndicator();
                                                }),
                                            SizedBox(
                                              width: media.size.height * 0.02,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(pro.allposts[index]
                                                            .userId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        return Text(
                                                          '${data!['username']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'MyFont',
                                                              fontSize: media
                                                                      .size
                                                                      .height *
                                                                  0.02 *
                                                                  1.1),
                                                        );
                                                      }
                                                      return CircularProgressIndicator();
                                                    }),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${DateFormat('h').format(pro.allposts[index].time)}',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              200,
                                                              187,
                                                              187),
                                                          fontSize: media
                                                                  .size.height *
                                                              0.02),
                                                    ),
                                                    Text(
                                                      ' hour ago',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              200,
                                                              187,
                                                              187),
                                                          fontSize: media
                                                                  .size.height *
                                                              0.02),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width:
                                                  media.size.height * 0.1 * 1.5,
                                            ),
                                            pro.allposts[index].userId !=
                                                    prov.userid
                                                ? StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(pro.allposts[index]
                                                            .userId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        Usermodel usermodel =
                                                            Usermodel.frommap(
                                                                data!);

                                                        return PopupMenuButton(
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'Block') {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                          ),
                                                                          height:
                                                                              media.size.height * 0.3,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
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
                                                                                    Provider.of<UserProvider>(context, listen: false).BlockUser(usermodel, prov);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'Block',
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

                                                                // Provider.of<UserProvider>(
                                                                //         context,
                                                                //         listen:
                                                                //             false)
                                                                //     .BlockUser(
                                                                //         prov,
                                                                //         usermodel);
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PostScreen(
                                                                            post:
                                                                                pro.allposts[index],
                                                                            userId: pro.allposts[index].userId,
                                                                            user: prov)));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            itemBuilder:
                                                                (context) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child: Text(usermodel
                                                                          .blockBy
                                                                          .contains(
                                                                              prov.userid)
                                                                      ? 'Unblock'
                                                                      : 'Block'),
                                                                  value:
                                                                      'Block',
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'View Post'),
                                                                  value:
                                                                      'View Post',
                                                                ),
                                                              ];
                                                            });
                                                      }
                                                      return Text('');
                                                    })
                                                : StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(prov.userid)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        Usermodel usermodel =
                                                            Usermodel.frommap(
                                                                data!);

                                                        return PopupMenuButton(
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'Delete') {
                                                                Provider.of<PostProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .deletePost(pro
                                                                        .allposts[
                                                                            index]
                                                                        .postId);
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PostScreen(
                                                                            post:
                                                                                pro.allposts[index],
                                                                            userId: pro.allposts[index].userId,
                                                                            user: prov)));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            itemBuilder:
                                                                (context) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'Delete'),
                                                                  value:
                                                                      'Delete',
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'View Post'),
                                                                  value:
                                                                      'View Post',
                                                                ),
                                                              ];
                                                            });
                                                      }
                                                      return Text('');
                                                    })
                                          ])),
                                      SizedBox(
                                        height: media.size.height * 0.02,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostScreen(
                                                        user: prov,
                                                        post:
                                                            pro.allposts[index],
                                                        userId: pro
                                                            .allposts[index]
                                                            .userId,
                                                      )));
                                        },
                                        child: Container(
                                            height: media.size.height * 0.3,
                                            width:
                                                media.size.height * 0.3 * 1.3,
                                            child: Image.network(
                                              pro.allposts[index].post,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: media.size.height * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<PostProvider>(context,
                                                      listen: false)
                                                  .likepost(
                                                      pro.allposts[index]
                                                          .postId,
                                                      prov);
                                            },
                                            child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('Post')
                                                    .doc(pro
                                                        .allposts[index].postId)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    var data =
                                                        snapshot.data!.data();
                                                    Postmodel post =
                                                        Postmodel.frommap(
                                                            data!);
                                                    return Icon(
                                                      post.likes.contains(
                                                              prov.userid)
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_outline,
                                                      color: Colors.white,
                                                      size: media.size.height *
                                                          0.03 *
                                                          1.2,
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
                                                  isScrollControlled: true,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      30))),
                                                  useSafeArea: false,
                                                  context: context,
                                                  backgroundColor: Colors.pink,
                                                  builder: (context) =>
                                                      CommentScreen(
                                                          userimage: prov.image,
                                                          username: prov.name,
                                                          postId: pro
                                                              .allposts[index]
                                                              .postId,
                                                          userId: prov.userid));
                                            },
                                            child: Icon(
                                              Icons.comment,
                                              color: Colors.white,
                                              size: media.size.height *
                                                  0.03 *
                                                  1.2,
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                media.size.height * 0.2 * 1.2,
                                          ),
                                          SavePost(
                                              postId:
                                                  pro.allposts[index].postId),
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.01,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02),
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    Likescontainer(
                                                      likes: pro.allposts[index]
                                                          .likes,
                                                      user: prov,
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                '${pro.allposts[index].likes.length}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        media.size.height *
                                                            0.02),
                                              ),
                                              SizedBox(
                                                  width:
                                                      media.size.height * 0.01),
                                              Text(
                                                'likes',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        media.size.height *
                                                            0.02),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02),
                                        child: Row(
                                          children: [
                                            Text(
                                              pro.allposts[index].caption,
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              25))),
                                              useSafeArea: false,
                                              context: context,
                                              backgroundColor: Colors.pink,
                                              builder: (context) =>
                                                  CommentScreen(
                                                      userimage: prov.image,
                                                      username: prov.name,
                                                      postId: pro
                                                          .allposts[index]
                                                          .postId,
                                                      userId: prov.userid));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: media.size.height * 0.02),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'View all Comments',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 200, 187, 187)),
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
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  var data =
                                                      snapshot.data!.data();

                                                  return CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            '${data!['image']}'),
                                                    radius: media.size.height *
                                                        0.03,
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
                                                controller: imagecomment,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                  hintText: 'Add Comment...',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 200, 187, 187)),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      200,
                                                                      187,
                                                                      187))),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      200,
                                                                      187,
                                                                      187))),
                                                ),
                                              )),
                                          InkWell(
                                              onTap: () async {
                                                if (imagecomment
                                                    .text.isNotEmpty) {
                                                  String commentId =
                                                      Uuid().v4();
                                                  Commentmodel model =
                                                      Commentmodel(
                                                          likes: [],
                                                          comment:
                                                              imagecomment.text,
                                                          commentId: commentId,
                                                          postId: pro
                                                              .allposts[index]
                                                              .postId,
                                                          userId: prov.userid);
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Post')
                                                      .doc(pro.allposts[index]
                                                          .postId)
                                                      .collection('comments')
                                                      .doc(commentId)
                                                      .set(model.toMap());
                                                  String Id = Uuid().v4();
                                                  NotificationModel notmodel =
                                                      NotificationModel(
                                                          commentId:
                                                              model.commentId,
                                                          currentuser:
                                                              prov.userid,
                                                          notificationId: Id,
                                                          notification:
                                                              model.comment,
                                                          otheruser: pro
                                                              .allposts[index]
                                                              .userId,
                                                          postId: pro
                                                              .allposts[index]
                                                              .postId,
                                                          time: DateTime.now());
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'notifications')
                                                      .doc(Id)
                                                      .set(notmodel.tomap());

                                                  imagecomment.clear();
                                                }
                                              },
                                              child: Icon(
                                                Icons.send,
                                                color: Colors.white,
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else if (data
                                .toLowerCase()
                                .contains(search.text.toLowerCase())) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: media.size.height * 0.02,
                                    left: media.size.height * 0.02,
                                    right: media.size.height * 0.02),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(235, 29, 29, 58),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  height: media.size.height * 0.1 * 6.6,
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: media.size.height * 0.02,
                                              top: media.size.height * 0.02),
                                          child: Row(children: [
                                            StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(pro
                                                        .allposts[index].userId)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    var data =
                                                        snapshot.data!.data();
                                                    Usermodel users =
                                                        Usermodel.frommap(
                                                            data!);
                                                    Usermodel.frommap(data);
                                                    String otheruserId = pro
                                                        .allposts[index].userId;
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => pro
                                                                            .allposts[
                                                                                index]
                                                                            .userId ==
                                                                        prov
                                                                            .userid
                                                                    ? MyProfile(
                                                                        value:
                                                                            false)
                                                                    : OtherUserProfile(
                                                                        otheruserId:
                                                                            otheruserId,
                                                                        otheruser:
                                                                            users)));
                                                      },
                                                      child: CircleAvatar(
                                                        radius:
                                                            media.size.height *
                                                                0.03,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                data['image']),
                                                      ),
                                                    );
                                                  }
                                                  return CircularProgressIndicator();
                                                }),
                                            SizedBox(
                                              width: media.size.height * 0.02,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(pro.allposts[index]
                                                            .userId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        return Text(
                                                          '${data!['username']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'MyFont',
                                                              fontSize: media
                                                                      .size
                                                                      .height *
                                                                  0.02 *
                                                                  1.1),
                                                        );
                                                      }
                                                      return CircularProgressIndicator();
                                                    }),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${DateFormat('h').format(pro.allposts[index].time)}',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              200,
                                                              187,
                                                              187),
                                                          fontSize: media
                                                                  .size.height *
                                                              0.02),
                                                    ),
                                                    Text(
                                                      ' hour ago',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              200,
                                                              187,
                                                              187),
                                                          fontSize: media
                                                                  .size.height *
                                                              0.02),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width:
                                                  media.size.height * 0.1 * 1.5,
                                            ),
                                            pro.allposts[index].userId !=
                                                    prov.userid
                                                ? StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(pro.allposts[index]
                                                            .userId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        Usermodel usermodel =
                                                            Usermodel.frommap(
                                                                data!);

                                                        return PopupMenuButton(
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'Block') {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                          ),
                                                                          height:
                                                                              media.size.height * 0.3,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
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
                                                                                    Provider.of<UserProvider>(context, listen: false).BlockUser(usermodel, prov);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'Block',
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

                                                                // Provider.of<UserProvider>(
                                                                //         context,
                                                                //         listen:
                                                                //             false)
                                                                //     .BlockUser(
                                                                //         prov,
                                                                //         usermodel);
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PostScreen(
                                                                            post:
                                                                                pro.allposts[index],
                                                                            userId: pro.allposts[index].userId,
                                                                            user: prov)));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            itemBuilder:
                                                                (context) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child: Text(usermodel
                                                                          .blockBy
                                                                          .contains(
                                                                              prov.userid)
                                                                      ? 'Unblock'
                                                                      : 'Block'),
                                                                  value:
                                                                      'Block',
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'View Post'),
                                                                  value:
                                                                      'View Post',
                                                                ),
                                                              ];
                                                            });
                                                      }
                                                      return Text('');
                                                    })
                                                : StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(prov.userid)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot
                                                            .data!
                                                            .data();
                                                        Usermodel usermodel =
                                                            Usermodel.frommap(
                                                                data!);

                                                        return PopupMenuButton(
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'Delete') {
                                                                Provider.of<PostProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .deletePost(pro
                                                                        .allposts[
                                                                            index]
                                                                        .postId);
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PostScreen(
                                                                            post:
                                                                                pro.allposts[index],
                                                                            userId: pro.allposts[index].userId,
                                                                            user: prov)));
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            itemBuilder:
                                                                (context) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'Delete'),
                                                                  value:
                                                                      'Delete',
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                      'View Post'),
                                                                  value:
                                                                      'View Post',
                                                                ),
                                                              ];
                                                            });
                                                      }
                                                      return Text('');
                                                    })
                                          ])),
                                      SizedBox(
                                        height: media.size.height * 0.02,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostScreen(
                                                        user: prov,
                                                        post:
                                                            pro.allposts[index],
                                                        userId: pro
                                                            .allposts[index]
                                                            .userId,
                                                      )));
                                        },
                                        child: Container(
                                            height: media.size.height * 0.3,
                                            width:
                                                media.size.height * 0.3 * 1.3,
                                            child: Image.network(
                                              pro.allposts[index].post,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: media.size.height * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<PostProvider>(context,
                                                      listen: false)
                                                  .likepost(
                                                      pro.allposts[index]
                                                          .postId,
                                                      prov);
                                            },
                                            child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('Post')
                                                    .doc(pro
                                                        .allposts[index].postId)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    var data =
                                                        snapshot.data!.data();
                                                    Postmodel post =
                                                        Postmodel.frommap(
                                                            data!);
                                                    return Icon(
                                                      post.likes.contains(
                                                              prov.userid)
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_outline,
                                                      color: Colors.white,
                                                      size: media.size.height *
                                                          0.03 *
                                                          1.2,
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
                                                  isScrollControlled: true,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      30))),
                                                  useSafeArea: false,
                                                  context: context,
                                                  backgroundColor: Colors.pink,
                                                  builder: (context) =>
                                                      CommentScreen(
                                                          userimage: prov.image,
                                                          username: prov.name,
                                                          postId: pro
                                                              .allposts[index]
                                                              .postId,
                                                          userId: prov.userid));
                                            },
                                            child: Icon(
                                              Icons.comment,
                                              color: Colors.white,
                                              size: media.size.height *
                                                  0.03 *
                                                  1.2,
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                media.size.height * 0.2 * 1.2,
                                          ),
                                          SavePost(
                                              postId:
                                                  pro.allposts[index].postId),
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.size.height * 0.01,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02),
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    Likescontainer(
                                                      likes: pro.allposts[index]
                                                          .likes,
                                                      user: prov,
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                '${pro.allposts[index].likes.length}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        media.size.height *
                                                            0.02),
                                              ),
                                              SizedBox(
                                                  width:
                                                      media.size.height * 0.01),
                                              Text(
                                                'likes',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        media.size.height *
                                                            0.02),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: media.size.height * 0.02),
                                        child: Row(
                                          children: [
                                            Text(
                                              pro.allposts[index].caption,
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              25))),
                                              useSafeArea: false,
                                              context: context,
                                              backgroundColor: Colors.pink,
                                              builder: (context) =>
                                                  CommentScreen(
                                                      userimage: prov.image,
                                                      username: prov.name,
                                                      postId: pro
                                                          .allposts[index]
                                                          .postId,
                                                      userId: prov.userid));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: media.size.height * 0.02),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'View all Comments',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 200, 187, 187)),
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
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  var data =
                                                      snapshot.data!.data();

                                                  return CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            '${data!['image']}'),
                                                    radius: media.size.height *
                                                        0.03,
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
                                                controller: imagecomment,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                  hintText: 'Add Comment...',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 200, 187, 187)),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      200,
                                                                      187,
                                                                      187))),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      200,
                                                                      187,
                                                                      187))),
                                                ),
                                              )),
                                          InkWell(
                                              onTap: () async {
                                                if (imagecomment
                                                    .text.isNotEmpty) {
                                                  String commentId =
                                                      Uuid().v4();
                                                  Commentmodel model =
                                                      Commentmodel(
                                                          likes: [],
                                                          comment:
                                                              imagecomment.text,
                                                          commentId: commentId,
                                                          postId: pro
                                                              .allposts[index]
                                                              .postId,
                                                          userId: prov.userid);
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Post')
                                                      .doc(pro.allposts[index]
                                                          .postId)
                                                      .collection('comments')
                                                      .doc(commentId)
                                                      .set(model.toMap());
                                                  String Id = Uuid().v4();
                                                  NotificationModel notmodel =
                                                      NotificationModel(
                                                          commentId:
                                                              model.commentId,
                                                          currentuser:
                                                              prov.userid,
                                                          notificationId: Id,
                                                          notification:
                                                              model.comment,
                                                          otheruser: pro
                                                              .allposts[index]
                                                              .userId,
                                                          postId: pro
                                                              .allposts[index]
                                                              .postId,
                                                          time: DateTime.now());
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'notifications')
                                                      .doc(Id)
                                                      .set(notmodel.tomap());

                                                  imagecomment.clear();
                                                }
                                              },
                                              child: Icon(
                                                Icons.send,
                                                color: Colors.white,
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {}
                          }
                        }),
                  );
                }),
              ]),
            ),
          );
  }
}
