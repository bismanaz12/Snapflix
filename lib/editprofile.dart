import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_app/imageprovider.dart';
import 'package:social_app/myprofile.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_switch/flutter_switch.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.value});
  bool value = false;
  bool namevalue = false;
  bool name = false;
  bool email = false;
  bool emailvalue = false;

  bool image = false;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<UserProvider>(context).user;
    var media = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(223, 12, 8, 19),
      body: Container(
        child: Stack(children: [
          Column(
            children: [
              Container(
                  width: double.infinity,
                  height: media.size.height * 0.1 * 2.8,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 96, 143),
                  ),
                  child: Image.asset(
                    'assets/images/beauty.jpg',
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                height: media.size.height * 0.1 * 1.5,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: media.size.height * 0.05,
                    bottom: media.size.height * 0.02),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      widget.namevalue = true;

                      widget.name = false;
                      name.clear();
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'regular',
                            fontSize: media.size.height * 0.02),
                      ),
                      widget.namevalue && widget.name == false
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: media.size.height * 0.03),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: media.size.height * 0.2 * 1.3,
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'regular',
                                          fontSize: media.size.height * 0.02),
                                      controller: name,
                                      decoration: InputDecoration(
                                          hintText: 'add name..',
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 228, 226, 226),
                                              fontFamily: 'regular'),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Color.fromARGB(
                                              255,
                                              238,
                                              96,
                                              143,
                                            ),
                                          )),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Color.fromARGB(
                                              255,
                                              238,
                                              96,
                                              143,
                                            ),
                                          ))),
                                    ),
                                  ),
                                  IconButton(
                                      style: IconButton.styleFrom(
                                        fixedSize: Size(
                                            media.size.height * 0.02,
                                            media.size.height * 0.03),
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          238,
                                          96,
                                          143,
                                        ),
                                        shape: CircleBorder(),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          widget.namevalue = false;
                                          widget.name = true;
                                        });
                                        if (name.text.isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(pro!.userid)
                                              .update({
                                            'username': name.text,
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.check_outlined,
                                        color: Color.fromARGB(223, 12, 8, 19),
                                      )),
                                ],
                              ),
                            )
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(pro!.userid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var data = snapshot.data!.data();
                                  Usermodel user = Usermodel.frommap(data!);

                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: media.size.height * 0.1),
                                    child: Text(
                                        widget.name && name.text.isNotEmpty
                                            ? name.text
                                            : user.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'regular',
                                            fontSize:
                                                media.size.height * 0.02)),
                                  );
                                }
                                return Text('');
                              })
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: media.size.height * 0.05,
                    right: media.size.height * 0.02),
                child: Divider(
                  thickness: media.size.height * 0.001,
                  color: Color.fromARGB(
                    255,
                    238,
                    96,
                    143,
                  ),
                ),
              ),
              SizedBox(
                height: media.size.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: media.size.height * 0.05,
                    bottom: media.size.height * 0.02),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      email.clear();
                      widget.emailvalue = true;
                      widget.email = false;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'regular',
                            fontSize: media.size.height * 0.02),
                      ),
                      widget.emailvalue
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: media.size.height * 0.03),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: media.size.height * 0.2 * 1.3,
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'regular',
                                          fontSize: media.size.height * 0.02),
                                      controller: email,
                                      decoration: InputDecoration(
                                          hintText: 'add email..',
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 228, 226, 226),
                                              fontFamily: 'regular'),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Color.fromARGB(
                                              255,
                                              238,
                                              96,
                                              143,
                                            ),
                                          )),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Color.fromARGB(
                                              255,
                                              238,
                                              96,
                                              143,
                                            ),
                                          ))),
                                    ),
                                  ),
                                  IconButton(
                                      style: IconButton.styleFrom(
                                        fixedSize: Size(
                                            media.size.height * 0.02,
                                            media.size.height * 0.03),
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          238,
                                          96,
                                          143,
                                        ),
                                        shape: CircleBorder(),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          widget.emailvalue = false;
                                          widget.email = true;
                                        });
                                        if (email.text.isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(pro!.userid)
                                              .update({'email': email.text});
                                        }
                                      },
                                      icon: Icon(
                                        Icons.check_outlined,
                                        color: Color.fromARGB(223, 12, 8, 19),
                                      )),
                                ],
                              ),
                            )
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(pro!.userid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var data = snapshot.data!.data();
                                  Usermodel user = Usermodel.frommap(data!);

                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: media.size.height * 0.1),
                                    child: Text(
                                        widget.email && email.text.isNotEmpty
                                            ? email.text
                                            : user.email,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'regular',
                                            fontSize:
                                                media.size.height * 0.02)),
                                  );
                                }
                                return Text('');
                              })
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: media.size.height * 0.05,
                    right: media.size.height * 0.02),
                child: Divider(
                  thickness: media.size.height * 0.001,
                  color: Color.fromARGB(
                    255,
                    238,
                    96,
                    143,
                  ),
                ),
              ),
              SizedBox(
                height: media.size.height * 0.1,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: media.size.height * 0.05,
                    bottom: media.size.height * 0.02),
                child: Row(
                  children: [
                    Text(
                      'Privacy ',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'regular',
                          fontSize: media.size.height * 0.02 * 1.2),
                    ),
                    Consumer<UserProvider>(builder: (context, pro, __) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: media.size.height * 0.02),
                        child: FlutterSwitch(
                            activeText: 'ON',
                            activeTextColor: Colors.black,
                            inactiveText: 'OFF',
                            inactiveTextColor: Colors.white,
                            width: media.size.height * 0.1,
                            showOnOff: true,
                            inactiveColor: Colors.brown,
                            activeColor: Color.fromARGB(255, 238, 96, 143),
                            toggleColor: Color.fromARGB(223, 12, 8, 19),
                            value: widget.value,
                            onToggle: (value) async {
                              widget.value = value;
                              setState(() {});
                              if (widget.value == true) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(pro.user!.userid)
                                    .update({'request': true});
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(pro.user!.userid)
                                    .update({'request': false});
                              }
                            }),
                      );
                    })
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: media.size.height * 0.1 * 1.1),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                            media.size.height * 0.2, media.size.height * 0.05),
                        backgroundColor: Color.fromARGB(255, 238, 96, 143),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(media.size.height * 0.03))),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Save changes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(223, 12, 8, 19),
                                fontFamily: 'MyFont'),
                          ),
                          Icon(
                            Icons.check_outlined,
                            size: media.size.height * 0.03,
                            color: Color.fromARGB(223, 12, 8, 19),
                          )
                        ],
                      )),
                ),
              )
            ],
          ),
          Positioned(
              top: media.size.height * 0.2,
              left: media.size.height * 0.1 * 1.6,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: media.size.height * 0.002,
                          color: Color.fromARGB(255, 238, 96, 143))),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(pro!.userid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.data();
                          Usermodel user = Usermodel.frommap(data!);
                          var prov = Provider.of<PickProvider>(context);

                          return prov.image != null
                              ? CircleAvatar(
                                  radius: media.size.height * 0.07,
                                  backgroundImage: FileImage(prov.image!),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(user.image),
                                  radius: media.size.height * 0.07,
                                );
                        }
                        return Text('');
                      }))),
          Positioned(
              top: media.size.height * 0.3,
              left: media.size.height * 0.1 * 2.4,
              child: widget.image
                  ? Consumer<PickProvider>(builder: (context, prov, __) {
                      return IconButton(
                          style: IconButton.styleFrom(
                            fixedSize: Size(media.size.height * 0.02,
                                media.size.height * 0.03),
                            backgroundColor: Color.fromARGB(
                              255,
                              238,
                              96,
                              143,
                            ),
                            shape: CircleBorder(),
                          ),
                          onPressed: () async {
                            String url = await downloadurl(prov.image!);
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(pro.userid)
                                .update({'image': url});
                            setState(() {
                              widget.image = false;
                            });
                          },
                          icon: Icon(
                            Icons.check_outlined,
                            color: Color.fromARGB(223, 12, 8, 19),
                          ));
                    })
                  : Consumer<PickProvider>(builder: (context, prov, __) {
                      return IconButton(
                          style: IconButton.styleFrom(
                            fixedSize: Size(media.size.height * 0.02,
                                media.size.height * 0.03),
                            backgroundColor: Color.fromARGB(
                              255,
                              238,
                              96,
                              143,
                            ),
                            shape: CircleBorder(),
                          ),
                          onPressed: () async {
                            Provider.of<PickProvider>(context, listen: false)
                                .pickimage();

                            setState(() {
                              widget.image = true;
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Color.fromARGB(223, 12, 8, 19),
                          ));
                    }))
        ]),
      ),
    );
  }
}
