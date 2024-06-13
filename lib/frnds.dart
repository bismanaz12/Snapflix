import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/chatpage.dart';
import 'package:social_app/messagesscreen.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({super.key, required this.user});
  Usermodel user;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 12, 8, 19),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('userId', isNotEqualTo: user!.userid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data();
                          Usermodel model = Usermodel.frommap(data);
                          if (model.followers.contains(user.userid)) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(user: model)));
                              },
                              child: FollowingUsers(
                                  otheruser: model,
                                  user: user,
                                  image: model.image,
                                  name: model.name),
                            );
                          } else {
                            return Text('');
                          }
                        });
                  }
                  return Text('');
                })
          ],
        ),
      ),
   
    );
  }
}

class FollowingUsers extends StatelessWidget {
  FollowingUsers({
    super.key,
    required this.image,
    required this.name,
    required this.otheruser,
    required this.user,
  });
  String image;
  String name;
  Usermodel otheruser;
  Usermodel user;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 238, 96, 143)),
                shape: BoxShape.circle),
            child: CircleAvatar(
              radius: media.size.height * 0.03 * 1.1,
              backgroundImage: NetworkImage(image),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                name,
                style: TextStyle(
                    color: Color.fromARGB(255, 238, 96, 143),
                    fontSize: media.size.height * 0.02,
                    fontFamily: 'MyFont'),
              ),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 238, 96, 143),
                  fixedSize: Size(
                      media.size.height * 0.1 * 1.5, media.size.height * 0.02)),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false)
                    .UnFollowuser(otheruser, user);
              },
              child: Center(
                child: Text(
                  'UnFollow',
                  style: TextStyle(
                      color: Color.fromARGB(223, 12, 8, 19),
                      fontSize: media.size.height * 0.02),
                ),
              ))
        ],
      ),
    );
   
    ;
  }
}
