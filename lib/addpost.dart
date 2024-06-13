import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/home.dart';
import 'package:social_app/imageprovider.dart';
import 'package:social_app/myprofile.dart';
import 'package:social_app/postmodel.dart';
import 'package:social_app/tagsscreen.dart';
import 'package:social_app/userprovider.dart';
import 'package:uuid/uuid.dart';

class Addpost extends StatelessWidget {
  Addpost({super.key});
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

  TextEditingController caption = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(223, 12, 8, 19),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: media.size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text(
                      'Add Post',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MyFont',
                          fontSize: media.size.height * 0.03),
                    ),
                  ),
                  SizedBox(
                    width: media.size.height * 0.1 * 2,
                  ),
                  Consumer<PickProvider>(builder: (context, pro, _) {
                    return InkWell(
                      onTap: () async {
                        if (caption.text.isNotEmpty ||
                            pro.image != null ||
                            pro.video != null) {
                          String postId = Uuid().v4();
                          String url = pro.image == null
                              ? await downloadurl(pro.video!)
                              : await downloadurl(pro.image!);

                          Postmodel model = Postmodel(
                              pinnedpost: false,
                              Tags: [],
                              caption: caption.text,
                              post: url,
                              postId: postId,
                              time: DateTime.now(),
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              likes: [],
                              posttype: pro.image != null
                                  ? postType.image
                                  : postType.video);
                          await FirebaseFirestore.instance
                              .collection('Post')
                              .doc(postId)
                              .set(model.tomap());

                          caption.clear();
                          pro.setimagenull(null);
                          pro.setvideonull(null);
                        }
                      },
                      child: Text(
                        'Share',
                        style: TextStyle(
                            color: Color.fromARGB(255, 238, 96, 143),
                            fontFamily: 'MyFont',
                            fontSize: media.size.height * 0.03 * 1.2),
                      ),
                    );
                  })
                ],
              ),
            ),
            SizedBox(
              height: media.size.height * 0.1,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 17.0, right: 17, top: 20),
                child: TextFormField(
                  maxLength: 70,
                  controller: caption,
                  style: TextStyle(color: Colors.white, fontFamily: 'MyFont'),
                  decoration: InputDecoration(
                      hintText: 'Caption',
                      hintStyle: TextStyle(
                          color: Color.fromARGB(255, 200, 187, 187),
                          fontFamily: 'regular'),
                      filled: true,
                      fillColor: Color.fromARGB(236, 17, 17, 36),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 200, 187, 187),
                              width: 0.2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 200, 187, 187),
                              width: 0.2))),
                )),
            SizedBox(
              height: media.size.height * 0.1,
            ),
            Consumer<PickProvider>(builder: (context, pro, _) {
              return Stack(children: [
                pro.image == null && pro.video == null
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                              media.size.height * 0.4,
                              media.size.height * 0.4,
                            ),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => CustomDialogue());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: media.size.height * 0.4,
                          width: media.size.height * 0.4,
                        ),
                      )
                    : pro.image != null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            height: media.size.height * 0.4,
                            width: media.size.height * 0.4,
                            child: Image.file(pro.image!),
                          )
                        : SizedBox(
                            height: media.size.height * 0.4,
                            width: media.size.height * 0.4,
                            child: Player(videoplayer: pro.video!)),
                pro.image == null && pro.video == null
                    ? Positioned(
                        top: media.size.height * 0.1 * 1.4,
                        left: media.size.height * 0.1 * 1.8,
                        child: Icon(
                          Icons.add_a_photo,
                          color: Color.fromARGB(255, 200, 187, 187),
                          size: media.size.height * 0.04,
                        ))
                    : Text(''),
                pro.image == null && pro.video == null
                    ? Positioned(
                        top: media.size.height * 0.2,
                        left: media.size.height * 0.1 * 1.3,
                        child: Text(
                          'click to add post',
                          style: TextStyle(
                              color: Color.fromARGB(255, 200, 187, 187),
                              fontFamily: 'MyFont',
                              fontSize: media.size.height * 0.02),
                        ))
                    : Text('')
              ]);
            })
          ],
        ),
      ),
    );
  }
}

class CustomDialogue extends StatelessWidget {
  const CustomDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: media.size.height * 0.1 * 2,
        width: media.size.height * 0.1 * 0.5,
        child: Column(
          children: [
            SizedBox(
              height: media.size.height * 0.03,
            ),
            Text(
              'select to pick',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'MyFont', fontSize: 20),
            ),
            SizedBox(height: media.size.height * 0.05),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20)),
                              side:
                                  BorderSide(color: Colors.black, width: 1.3)),
                          fixedSize: Size(media.size.height * 0.1 * 1.5,
                              media.size.height * 0.1 * 0.8)),
                      onPressed: () {
                        Provider.of<PickProvider>(context, listen: false)
                            .pickimage();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Image',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MyFont',
                            fontSize: media.size.height * 0.02),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20)),
                              side:
                                  BorderSide(color: Colors.black, width: 1.3)),
                          fixedSize: Size(media.size.height * 0.1 * 1.5,
                              media.size.height * 0.1 * 0.8)),
                      onPressed: () {
                        Provider.of<PickProvider>(context, listen: false)
                            .pickvideo();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Video',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MyFont',
                            fontSize: media.size.height * 0.02),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
