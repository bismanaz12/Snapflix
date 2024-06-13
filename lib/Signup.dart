import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:social_app/imageprovider.dart';
import 'package:social_app/login.dart';
import 'package:social_app/usermodel.dart';
import 'package:uuid/uuid.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpass = TextEditingController();

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
              height: media.size.height * 0.1 * 0.85,
            ),
            Text(
              'Register yourself',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: media.size.height * 0.02,
                  fontFamily: 'MyFont'),
            ),
            SizedBox(
              height: 25,
            ),
            Stack(children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), shadowColor: Colors.white),
                  onPressed: () {
                    Provider.of<PickProvider>(context, listen: false)
                        .pickimage();
                  },
                  child: Provider.of<PickProvider>(context).image == null
                      ? CircleAvatar(
                          backgroundColor: Color.fromARGB(238, 11, 11, 30),
                          radius: media.size.height * 0.1 * 1.2,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(
                              Provider.of<PickProvider>(context, listen: false)
                                  .image!),
                          radius: media.size.height * 0.1 * 1.2,
                        )),
              Positioned(
                  top: 80,
                  left: 120,
                  child: Provider.of<PickProvider>(context).image == null
                      ? Icon(
                          Icons.camera_alt_outlined,
                          color: Color.fromARGB(255, 200, 187, 187),
                          size: media.size.height * 0.1 * 0.3,
                        )
                      : Text('')),
              Positioned(
                  top: 120,
                  left: 70,
                  child:
                      Provider.of<PickProvider>(context, listen: false).image ==
                              null
                          ? Text(
                              'upload image',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 200, 187, 187),
                                  fontFamily: 'regular',
                                  fontSize: media.size.height * 0.1 * 0.2),
                            )
                          : Text(''))
            ]),
            SizedBox(
              height: media.size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 17),
              child: TextFormField(
                controller: name,
                style: TextStyle(
                    color: Color.fromARGB(255, 200, 187, 187),
                    fontFamily: 'MyFont'),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(236, 17, 17, 36),
                    hintText: ' User name',
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 200, 187, 187),
                        fontFamily: 'regular'),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 17, top: 20),
              child: TextFormField(
                controller: email,
                style: TextStyle(
                    color: Color.fromARGB(255, 200, 187, 187),
                    fontFamily: 'MyFont'),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(236, 17, 17, 36),
                    hintText: ' Email',
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 200, 187, 187),
                        fontFamily: 'regular'),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 17, top: 20),
              child: TextFormField(
                controller: password,
                style: TextStyle(
                    color: Color.fromARGB(255, 200, 187, 187),
                    fontFamily: 'MyFont'),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(236, 17, 17, 36),
                    suffixIcon: Icon(
                      Icons.remove_red_eye,
                      color: Color.fromARGB(255, 200, 187, 187),
                    ),
                    hintText: ' Password',
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 200, 187, 187),
                        fontFamily: 'regular'),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 17, top: 20),
              child: TextFormField(
                controller: confirmpass,
                style: TextStyle(
                    color: Color.fromARGB(255, 200, 187, 187),
                    fontFamily: 'MyFont'),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(236, 17, 17, 36),
                    suffixIcon: Icon(
                      Icons.password_outlined,
                      color: Color.fromARGB(255, 200, 187, 187),
                    ),
                    hintText: ' Confirm Password',
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 200, 187, 187),
                        fontFamily: 'regular'),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 200, 187, 187),
                            width: 0.2))),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.1 * 1.3,
            ),
            Consumer<PickProvider>(builder: (context, pro, _) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(media.size.height * 0.4,
                          media.size.height * 0.1 * 0.6),
                      backgroundColor: Color.fromARGB(255, 238, 96, 143),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onPressed: () async {
                    if (email.text.isNotEmpty &&
                        name.text.isNotEmpty &&
                        pro.image != null &&
                        password.text.isNotEmpty &&
                        confirmpass.text.isNotEmpty) {
                      try {
                        if (password.text == confirmpass.text) {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          FirebaseFirestore fire = FirebaseFirestore.instance;
                          String url = await downloadurl(pro.image!);
                          UserCredential user =
                              await auth.createUserWithEmailAndPassword(
                                  email: email.text, password: password.text);
                          Usermodel usermodel = Usermodel(
                              request: false,
                              requested: [],
                              blockBy: [],
                              blockUser: [],
                              email: email.text,
                              name: name.text,
                              password: password.text,
                              userid: user.user!.uid,
                              image: url,
                              followers: [],
                              followings: []);

                          await fire
                              .collection('users')
                              .doc(user.user!.uid)
                              .set(usermodel.tomap());

                          email.clear();
                          name.clear();
                          password.clear();
                          confirmpass.clear();
                          Provider.of<PickProvider>(context, listen: false)
                              .setimagenull(null);
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MyFont',
                        fontSize: media.size.height * 0.1 * 0.3),
                  ));
            })
          ],
        ),
      ),
    );
  }
}
