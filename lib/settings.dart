import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/blocklist.dart';
import 'package:social_app/editprofile.dart';
import 'package:social_app/myprofile.dart';
import 'package:social_app/notificationsscreen.dart';
import 'package:social_app/usermodel.dart';
import 'package:social_app/userprovider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key, required this.user});
  Usermodel user;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 12, 8, 19),
      body: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          Text(
            'Settings',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            height: 40,
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BlockScreen()));
            },
            title: Text(
              'BlockList',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'MyFont', fontSize: 20),
            ),
            trailing: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 23,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfile(value: false)));
            },
            title: Text(
              'EditProfile',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'MyFont', fontSize: 20),
            ),
            trailing: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 23,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NotificationsScreen(user: widget.user)));
            },
            title: Text(
              'Notifications',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'MyFont', fontSize: 20),
            ),
            trailing: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 23,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyProfile(value: false)));
            },
            title: Text(
              'Profile',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'MyFont', fontSize: 20),
            ),
            trailing: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 23,
            ),
          ),

          // InkWell(
          //   onTap: () async {
          //     Provider.of<UserProvider>(context, listen: false)
          //         .confimrId(widget.currentuser, widget.otheruser!);
          //   },
          //   child: Text('blue'),
          // ),
        ],
      ),
    );
  }
}
