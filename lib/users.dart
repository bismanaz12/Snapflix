import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/chatpage.dart';
import 'package:social_app/otheruserprofile.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var pro = Provider.of<UserProvider>(context).user;
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 12, 8, 19),
      body: Container(
        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        child: Column(
          children: [
            SizedBox(
              height: media.size.height * 0.06,
            ),
            Text(
              'Suggestion',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MyFont',
                  fontSize: media.size.height * 0.02 * 1.2),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('userId',
                        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: media.size.height * 0.02,
                            mainAxisSpacing: media.size.height * 0.02),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data();
                          Usermodel model = Usermodel.frommap(data);

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            user: model,
                                          )));
                            },
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtherUserProfile(
                                            otheruser: model,
                                            otheruserId: model.userid)));
                              },
                              child: UserContainer(
                                  user: pro!,
                                  otheruser: model,
                                  image: model.image,
                                  name: model.name),
                            ),
                          );
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

class UserContainer extends StatelessWidget {
  UserContainer(
      {super.key,
      required this.image,
      required this.name,
      required this.otheruser,
      required this.user});
  String image;
  String name;
  Usermodel otheruser;
  Usermodel user;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);

    return Container(
      height: media.size.height * 0.1,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Color.fromARGB(255, 238, 96, 143)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: media.size.height * 0.001,
                  color: Color.fromARGB(223, 12, 8, 19),
                )),
            child: CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: media.size.height * 0.06,
            ),
          ),
          Text(
            name,
            style: TextStyle(
                color: Color.fromARGB(223, 12, 8, 19),
                fontSize: media.size.height * 0.02,
                fontFamily: 'MyFont'),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(223, 12, 8, 19),
                  fixedSize:
                      Size(media.size.height * 0.2, media.size.height * 0.04)),
              onPressed: () {
                otheruser.followers.contains(user.userid)
                    ? showDialog(
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
                                        NetworkImage(otheruser.image),
                                  ),
                                  Container(
                                      width: media.size.height * 0.3,
                                      child: Expanded(
                                        child: Text(
                                            "If you change your mind, you'll have to request to follow ${otheruser.name} again."),
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 238, 96, 143),
                                          fixedSize: Size(
                                              media.size.height * 0.1 * 1.5,
                                              media.size.height * 0.02)),
                                      onPressed: () {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .UnFollowuser(otheruser, user);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'UnFollow',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(223, 12, 8, 19),
                                            fontSize: media.size.height * 0.02),
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          fixedSize: Size(
                                              media.size.height * 0.1 * 1.5,
                                              media.size.height * 0.02)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(223, 12, 8, 19),
                                            fontSize: media.size.height * 0.02),
                                      ))
                                ],
                              ),
                            ),
                          );
                        })
                    : Provider.of<UserProvider>(context, listen: false)
                        .followuser(otheruser, user);
              },
              child: Text(
                otheruser.followers.contains(user.userid)
                    ? 'Following'
                    : otheruser.requested.contains(user.userid)
                        ? 'Requested'
                        : 'Follow',
                style: TextStyle(
                    color: Color.fromARGB(255, 238, 96, 143),
                    fontSize: media.size.height * 0.02),
              ))
        ],
      ),
    );
  }
}
