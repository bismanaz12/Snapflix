import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_app/commentmodel.dart';
import 'package:social_app/notificationmodel.dart';
import 'package:social_app/postmodel.dart';
import 'package:social_app/repliescommentmodel.dart';
import 'package:social_app/usermodel.dart';
import 'package:uuid/uuid.dart';

class PostProvider with ChangeNotifier {
  List<Postmodel> postmodel = [];
  List<Postmodel> allposts = [];
  // List<String> tagedIds = [];
  List<Usermodel> tagedUsers = [];

  addtagedUser(Usermodel user) {
    tagedUsers.add(user);
    notifyListeners();
  }

  removeTagUser(Usermodel user) {
    tagedUsers.remove(user);
    notifyListeners();
  }

  // addtagedId(String id) {
  //   tagedIds.add(id);
  //   notifyListeners();
  // }

  // removetagedId(String id) {
  //   tagedIds.remove(id);
  //   notifyListeners();
  // }

  getCureentuserPost() async {
    await FirebaseFirestore.instance
        .collection('Post')
        .where('userId ', isEqualTo: 'A7Oo8yUfsEegZocnlnYuN2aFOav1')
        .get()
        .then((value) {
      log('User Posts are ${value.docs}');
      postmodel = value.docs.map((e) => Postmodel.frommap(e.data())).toList();
      notifyListeners();
    });
  }

  getallpost() {
    FirebaseFirestore.instance.collection('Post').get().then((value) {
      log('posts are ${value.docs.first.data()}');
      allposts = value.docs.map((e) => Postmodel.frommap(e.data())).toList();
      notifyListeners();
    });
  }

  updateLikePost(String postId, String userId) {
    int index = allposts.indexWhere((element) => element.postId == postId);
    allposts[index].likes.add(userId);
    notifyListeners();
  }

  removeLikePost(String postId, String userId) {
    int index = allposts.indexWhere((element) => element.postId == postId);
    allposts[index].likes.remove(userId);
    notifyListeners();
  }

  likepost(
    String postId,
    Usermodel userId,
  ) async {
    var prov =
        await FirebaseFirestore.instance.collection('Post').doc(postId).get();
    Postmodel post = Postmodel.frommap(prov.data()!);
    if (post.likes.contains(userId.userid)) {
      removeLikePost(postId, userId.userid);
      await FirebaseFirestore.instance.collection('Post').doc(postId).update({
        'likes': FieldValue.arrayRemove([userId.userid])
      });
    } else {
      updateLikePost(postId, userId.userid);
      await FirebaseFirestore.instance.collection('Post').doc(postId).update({
        'likes': FieldValue.arrayUnion([userId.userid])
      });
      String Id = Uuid().v4();
      NotificationModel model = NotificationModel(
          commentId: '',
          postId: post.postId,
          currentuser: userId.userid,
          notificationId: Id,
          notification: 'like your Post',
          otheruser: post.userId,
          time: DateTime.now());

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(Id)
          .set(model.tomap());
    }
  }

  pinpost(bool pinned, String postId) async {
    List<Postmodel> pinnedpost = [];
    for (var post in allposts) {
      if (post.pinnedpost) {
        pinnedpost.add(post);
      }
    }

    if (pinnedpost.length < 2 || !pinned) {
      for (var post in allposts) {
        if (post.postId == postId) {
          post.pinnedpost = pinned;
          notifyListeners();
        }
        await FirebaseFirestore.instance.collection('Post').doc(postId).update({
          'pinnedpost': pinned,
        });

        // if (pinned) {
        //   allposts.insert(0, post);
        // }
      }
    }
  }

  likecomment(String commentId, Usermodel user, String postId) async {
    var comment = await FirebaseFirestore.instance
        .collection('Post')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .get();
    Commentmodel comments = Commentmodel.fromMap(comment.data()!);
    if (comments.likes.contains(user.userid)) {
      await FirebaseFirestore.instance
          .collection('Post')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([user.userid])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Post')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([user.userid])
      });
      String Id = Uuid().v4();
      NotificationModel model = NotificationModel(
          commentId: comments.commentId,
          postId: comments.postId,
          currentuser: user.userid,
          notificationId: Id,
          notification: 'like your comment',
          otheruser: comments.userId,
          time: DateTime.now());

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(Id)
          .set(model.tomap());
    }
  }

  likecommentreply(String replycommentId, String commentId, Usermodel user,
      String postId) async {
    var replycomment = await FirebaseFirestore.instance
        .collection('Post')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replycomments')
        .doc(replycommentId)
        .get();
    ReplyComments replycomments = ReplyComments.fromMap(replycomment.data()!);
    if (replycomments.likes.contains(user.userid)) {
      await FirebaseFirestore.instance
          .collection('Post')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .collection('replycomments')
          .doc(replycommentId)
          .update({
        'likes': FieldValue.arrayRemove([user.userid])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Post')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .collection('replycomments')
          .doc(replycommentId)
          .update({
        'likes': FieldValue.arrayUnion([user.userid])
      });
      String Id = Uuid().v4();
      NotificationModel model = NotificationModel(
          commentId: replycomments.replyId,
          postId: replycomments.postId,
          currentuser: user.userid,
          notificationId: Id,
          notification: 'like your comment',
          otheruser: replycomments.userId,
          time: DateTime.now());

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(Id)
          .set(model.tomap());
    }
  }

  addtags(Usermodel user, String PostId) async {
    if (PostId.contains(user.userid)) {
      tagedUsers.remove(user);
    } else {
      tagedUsers.add(user);
    }
    notifyListeners();
  }

  deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('Post').doc(postId).delete();
  }
}
