import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/notificationmodel.dart';
import 'package:social_app/usermodel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  Usermodel? user;
  List<Usermodel>? users;
  Usermodel? otheruser;
  File? image;

  getUsers() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      user = Usermodel.frommap(value.data()!);
      notifyListeners();
    });
  }

  getallUsers() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      users = value.docs.map((e) => Usermodel.frommap(e.data())).toList();
      notifyListeners();
    });
  }

  getotheruser(String otheruserId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(otheruserId)
        .get()
        .then((value) {
      otheruser = Usermodel.frommap(value.data()!);
      notifyListeners();
    });
  }

  followuser(Usermodel otheruser, Usermodel user) async {
    if (otheruser.followers.contains(user.userid)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(otheruser.userid)
          .update({
        'followers': FieldValue.arrayRemove([user.userid])
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userid)
          .update({
        'followings': FieldValue.arrayRemove([otheruser.userid])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(otheruser.userid)
          .update({
        'followers': FieldValue.arrayUnion([user.userid])
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userid)
          .update({
        'followings': FieldValue.arrayUnion([otheruser.userid])
      });
    }
  }

  UnFollowuser(Usermodel otheruser, Usermodel user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(otheruser.userid)
        .update({
      'followers': FieldValue.arrayRemove([user.userid])
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userid)
        .update({
      'followings': FieldValue.arrayRemove([otheruser.userid])
    });
  }

  BlockUser(Usermodel currentusermodel, Usermodel otherusermodel) async {
    if (otherusermodel.blockBy.contains(currentusermodel.userid)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(otherusermodel.userid)
          .update({
        'blockBy': FieldValue.arrayRemove(
          [currentusermodel.userid],
        )
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentusermodel.userid)
          .update({
        'blockUser': FieldValue.arrayRemove(
          [otherusermodel.userid],
        )
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(otherusermodel.userid)
          .update({
        'blockBy': FieldValue.arrayUnion([currentusermodel.userid])
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentusermodel.userid)
          .update({
        'blockUser': FieldValue.arrayUnion(
          [otherusermodel.userid],
        )
      });
    }
  }

  requestUser(Usermodel currentUser, Usermodel requestUser) async {
    if (!requestUser.followers.contains(currentUser.userid)) {
      if (requestUser.request == true) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(requestUser.userid)
            .update({
          'requested': FieldValue.arrayUnion([currentUser.userid])
        });
        String Id = Uuid().v4();
        NotificationModel model = NotificationModel(
            commentId: '',
            postId: '',
            notificationId: Id,
            currentuser: currentUser.userid,
            notification: '',
            otheruser: requestUser.userid,
            time: DateTime.now());

        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(Id)
            .set(model.tomap());
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(requestUser.userid)
            .update({
          'followers': FieldValue.arrayUnion([currentUser.userid])
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.userid)
            .update({
          'followings': FieldValue.arrayUnion([requestUser.userid])
        });
      }
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(requestUser.userid)
          .update({
        'followers': FieldValue.arrayRemove([currentUser.userid])
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.userid)
          .update({
        'followings': FieldValue.arrayRemove([requestUser.userid])
      });
    }
  }

  confimrId(Usermodel currentId, Usermodel otherId, String notifiId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(otherId.userid)
        .update({
      'requested': FieldValue.arrayRemove([currentId.userid])
    });
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notifiId)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(otherId.userid)
        .update({
      'followers': FieldValue.arrayUnion([currentId.userid])
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentId.userid)
        .update({
      'followings': FieldValue.arrayUnion([otherId.userid])
    });
  }

  updatepic() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedimage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      image = File(pickedimage.path);
      notifyListeners();
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.userid)
        .update({'image': image});
  }

  followPostuser(Usermodel otheruser, Usermodel user) async {
    if (!otheruser.followers.contains(user.userid)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(otheruser.userid)
          .update({
        'followers': FieldValue.arrayUnion([user.userid])
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userid)
          .update({
        'followings': FieldValue.arrayUnion([otheruser.userid])
      });
    }
  }

  UnfollowPostuser(Usermodel otheruser, Usermodel user) async {
    if (otheruser.followers.contains(user.userid)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(otheruser.userid)
          .update({
        'followers': FieldValue.arrayRemove([user.userid])
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userid)
          .update({
        'followings': FieldValue.arrayRemove([otheruser.userid])
      });
    }
  }

  UnBlockUser(Usermodel currentusermodel, Usermodel otherusermodel) async {
    if (otherusermodel.blockBy.contains(currentusermodel.userid)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(otherusermodel.userid)
          .update({
        'blockBy': FieldValue.arrayRemove(
          [currentusermodel.userid],
        )
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentusermodel.userid)
          .update({
        'blockUser': FieldValue.arrayRemove(
          [otherusermodel.userid],
        )
      });
    }
  }
}
