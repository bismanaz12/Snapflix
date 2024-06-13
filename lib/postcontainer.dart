import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_app/postprovider.dart';
import 'package:social_app/userprovider.dart';

class PostContainer extends StatelessWidget {
  PostContainer(
      {super.key,
      required this.post,
      required this.currentuserimage,
      required this.otheruserimage,
      required this.time,
      required this.txt1});
  String txt1;
  String otheruserimage;
  String currentuserimage;
  String post;
  DateTime time;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
          left: media.size.height * 0.02, right: media.size.height * 0.02),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(235, 29, 29, 58),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        height: media.size.height * 0.1 * 6,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: media.size.height * 0.03,
                  backgroundImage: NetworkImage(otheruserimage),
                ),
                Column(
                  children: [
                    Text(
                      txt1,
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'MyFont'),
                    ),
                    Text(
                      '${time}',
                      style: TextStyle(
                          color: Color.fromARGB(255, 200, 187, 187),
                          fontSize: media.size.height * 0.02),
                    ),
                  ],
                ),
                Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              ],
            ),
            // ListTile(
            //   leading: CircleAvatar(
            //     radius: media.size.height * 0.03,
            //     backgroundImage: NetworkImage(otheruserimage),
            //   ),
            //   title: Text(
            //     txt1,
            //     style: TextStyle(color: Colors.white, fontFamily: 'MyFont'),
            //   ),
            //   subtitle: Text(
            //     '${time}',
            //     style: TextStyle(
            //         color: Color.fromARGB(255, 200, 187, 187),
            //         fontSize: media.size.height * 0.02),
            //   ),
            //   trailing: Icon(
            //     Icons.more_horiz,
            //     color: Colors.white,
            //   ),
            // ),
            SizedBox(
              height: media.size.height * 0.02,
            ),
            Container(
              height: media.size.height * 0.3,
              width: media.size.height * 0.3 * 1.3,
              child: Image.network(
                post,
                fit: BoxFit.cover,
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
                Icon(
                  Icons.favorite_outline,
                  color: Colors.white,
                  size: media.size.height * 0.03 * 1.2,
                ),
                SizedBox(
                  width: media.size.height * 0.02,
                ),
                Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: media.size.height * 0.03 * 1.2,
                ),
                SizedBox(
                  width: media.size.height * 0.2 * 1.3,
                ),
                Icon(
                  Icons.bookmark_border_outlined,
                  color: Colors.white,
                  size: media.size.height * 0.03 * 1.2,
                ),
              ],
            ),
            SizedBox(
              height: media.size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.only(left: media.size.height * 0.02),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'View all Comments',
                  style: TextStyle(color: Color.fromARGB(255, 200, 187, 187)),
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
                CircleAvatar(
                  backgroundImage: NetworkImage(currentuserimage),
                  radius: media.size.height * 0.03,
                ),
                SizedBox(
                  width: media.size.height * 0.01,
                ),
                SizedBox(
                    width: media.size.height * 0.3,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Add Comment...',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 200, 187, 187)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 187, 187))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 200, 187, 187))),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
