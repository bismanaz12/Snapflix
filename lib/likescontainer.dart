import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/postmodel.dart';
import 'package:social_app/postprovider.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';

class Likescontainer extends StatelessWidget {
  Likescontainer({super.key, required this.user, required this.likes});
  Usermodel user;
  List likes;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Dialog(
      child: Stack(children: [
        Consumer<PostProvider>(builder: (context, pro, _) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: media.size.height * 0.4 * 1.3,
            child: Column(
              children: [
                Text(
                  'Likes',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: media.size.height * 0.02 * 1.2,
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: media.size.height * 0.001,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('userId', whereIn: likes)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!.docs
                            .map((e) => Usermodel.frommap(e.data()))
                            .toList();

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: media.size.height * 0.02),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: media.size.height * 0.03,
                                      backgroundImage:
                                          NetworkImage(data[index].image),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          data[index].name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'MyFont',
                                              fontSize:
                                                  media.size.height * 0.02,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    data[index].userid != user.userid
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: media.size.height * 0.02),
                                            child: ElevatedButton(
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
                                                  data[index]
                                                          .followers
                                                          .contains(user.userid)
                                                      ? showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                ),
                                                                height: media
                                                                        .size
                                                                        .height *
                                                                    0.3,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    SizedBox(
                                                                      height: media
                                                                              .size
                                                                              .height *
                                                                          0.02,
                                                                    ),
                                                                    CircleAvatar(
                                                                      radius: media
                                                                              .size
                                                                              .height *
                                                                          0.05,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              data[index].image),
                                                                    ),
                                                                    Container(
                                                                        width: media.size.height *
                                                                            0.3,
                                                                        child:
                                                                            Expanded(
                                                                          child:
                                                                              Text("If you change your mind, you'll have to request to follow ${data[index].name} again."),
                                                                        )),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Color.fromARGB(
                                                                                255,
                                                                                238,
                                                                                96,
                                                                                143),
                                                                            fixedSize:
                                                                                Size(media.size.height * 0.1 * 1.5, media.size.height * 0.02)),
                                                                        onPressed: () {
                                                                          Provider.of<UserProvider>(context, listen: false).UnFollowuser(
                                                                              data[index],
                                                                              user);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                          'UnFollow',
                                                                          style: TextStyle(
                                                                              color: Color.fromARGB(223, 12, 8, 19),
                                                                              fontSize: media.size.height * 0.02),
                                                                        )),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            fixedSize: Size(media.size.height * 0.1 * 1.5, media.size.height * 0.02)),
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                          'Cancel',
                                                                          style: TextStyle(
                                                                              color: Color.fromARGB(223, 12, 8, 19),
                                                                              fontSize: media.size.height * 0.02),
                                                                        ))
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          })
                                                      : Provider.of<
                                                                  UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .followuser(
                                                              data[index],
                                                              user);
                                                },
                                                child: Text(
                                                  data[index]
                                                          .followers
                                                          .contains(user.userid)
                                                      ? 'Following'
                                                      : data[index]
                                                              .requested
                                                              .contains(
                                                                  user.userid)
                                                          ? 'Requested'
                                                          : 'Follow',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          223, 12, 8, 19),
                                                      fontSize:
                                                          media.size.height *
                                                              0.02),
                                                )),
                                          )
                                        : Text(''),
                                  ],
                                ),
                              );
                            });
                      }
                      return Text('');
                    }),
              ],
            ),
          );
        }),
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
  }
}
