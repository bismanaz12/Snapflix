import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/postmodel.dart';
import 'package:social_app/postprovider.dart';
import 'package:social_app/usermodel.dart';

class TagsScreen extends StatefulWidget {
  TagsScreen({
    super.key,
  });

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  late StreamSubscription<QuerySnapshot> streamPro;
  List<Usermodel> data = [];

  @override
  void initState() {
    getStreamData();
    super.initState();
  }

  getStreamData() {
    streamPro = FirebaseFirestore.instance
        .collection('users')
        .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      List<Usermodel> users =
          snapshot.docs.map((e) => Usermodel.frommap(e.data())).toList();

      setState(() {
        data = users;
      });
    });
  }

  List tagsId = [];

  List<Usermodel> tagedUsers = [];
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Container(
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
      child: Consumer<PostProvider>(builder: (context, pro, _) {
        return Column(
          children: [
            GridView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: media.size.height * 0.1 * 1.5,
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  // var data = data;
                  var user = data[index];
                  return InkWell(
                    onTap: () {
                      Provider.of<PostProvider>(context, listen: false)
                          .addtags(user, pro.allposts[index].postId);

                      // int? userData;
                      // if (postPro.tagedUsers.isNotEmpty) {
                      //   userData = postPro.tagedUsers.indexWhere(
                      //       (element) => element.userid == user.userid);
                      // }
                      // log('tagedUsers are ${postPro.tagedUsers}');
                      // if (postPro.tagedUsers.contains(user)) {
                      //   postPro.removeTagUser(user);
                      // } else {
                      //   postPro.addtagedUser(user);
                      // }
                    },
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: media.size.height * 0.03,
                          ),
                          CircleAvatar(
                            radius: media.size.height * 0.04,
                            backgroundImage: NetworkImage(user.image),
                          ),
                          Text(
                            user.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'MyFont',
                                fontSize: media.size.height * 0.02),
                          )
                        ],
                      ),
                    ),
                  );
                })
          ],
        );
      }),
    );
  }
}
