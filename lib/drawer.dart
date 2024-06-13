import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_app/addpost.dart';
import 'package:social_app/blocklist.dart';
import 'package:social_app/frnds.dart';
import 'package:social_app/login.dart';
import 'package:social_app/messagesscreen.dart';
import 'package:social_app/myprofile.dart';
import 'package:social_app/notificationsscreen.dart';
import 'package:social_app/settings.dart';
import 'package:social_app/userprovider.dart';
import 'package:social_app/users.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);

    var otheruser = Provider.of<UserProvider>(
      context,
    ).otheruser;

    return Consumer<UserProvider>(builder: (context, pro, _) {
      return Drawer(
          elevation: 3,
          child: ListView(padding: EdgeInsets.zero, children: [
            UserAccountsDrawerHeader(
              accountName: Padding(
                padding: EdgeInsets.only(left: media.size.height * 0.01 * 1.1),
                child: Text(
                  '${pro.user!.name}',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MyFont',
                      fontSize: media.size.height * 0.02),
                ),
              ),
              accountEmail: Text(
                '${pro.user!.email}',
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(pro.user!.image),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/hands.png',
                      ),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: media.size.height * 0.04,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addpost()));
              },
              leading: FaIcon(
                Icons.add_box_outlined,
                color: Colors.black,
                size: media.size.height * 0.03,
              ),
              title: Text(
                'Create Post',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'regular',
                    fontSize: media.size.height * 0.02 * 1.2),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.03,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendsPage(user: pro.user!)));
              },
              leading: FaIcon(
                Icons.person_2_outlined,
                color: Colors.black,
                size: media.size.height * 0.03,
              ),
              title: Text(
                'Friends',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'regular',
                    fontSize: media.size.height * 0.02 * 1.2),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.03,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsScreen(
                              user: pro.user!,
                            )));
              },
              leading: FaIcon(
                Icons.favorite_outline,
                color: Colors.black,
                size: media.size.height * 0.03,
              ),
              title: Text(
                'Notification',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'regular',
                    fontSize: media.size.height * 0.02 * 1.2),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.03,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessagesScreen()));
              },
              leading: FaIcon(
                Icons.message_outlined,
                color: Colors.black,
                size: media.size.height * 0.03,
              ),
              title: Text(
                'Messages',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'regular',
                    fontSize: media.size.height * 0.02 * 1.2),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.03,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UsersPage()));
              },
              leading: Icon(Icons.settings_suggest_outlined),
              title: Text(
                'Suggestion',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'regular',
                    fontSize: media.size.height * 0.02 * 1.1),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.03,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyProfile(value: pro.user!.request)));
              },
              leading: CircleAvatar(
                radius: media.size.height * 0.02,
                backgroundImage: NetworkImage(pro.user!.image),
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'regular',
                    fontSize: media.size.height * 0.02 * 1.1),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.03,
            ),
            ListTile(
              onTap: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                await auth.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              leading: Icon(
                Icons.logout,
                color: Colors.black,
                size: media.size.height * 0.03,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'regular',
                    fontSize: media.size.height * 0.02 * 1.2),
              ),
            ),
            SizedBox(
              height: media.size.height * 0.03,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              user: pro.user!,
                            )));
              },
              leading: Icon(
                Icons.settings_outlined,
                color: Colors.black,
                size: media.size.height * 0.03,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'regular',
                    fontSize: media.size.height * 0.02 * 1.1),
              ),
            ),
          ]));
    });
  }
}
