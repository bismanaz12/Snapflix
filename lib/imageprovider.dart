import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

class PickProvider with ChangeNotifier {
  File? image;
  File? video;

  pickimage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedimage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      image = File(pickedimage.path);
    }
    notifyListeners();
  }

  setimagenull(value) {
    image = value;
    notifyListeners();
  }

  pickvideo() async {
    ImagePicker videopicker = ImagePicker();
    XFile? pickedvideo =
        await videopicker.pickVideo(source: ImageSource.gallery);
    if (pickedvideo != null) {
      video = File(pickedvideo.path);
    }
    notifyListeners();
  }

  setvideonull(value) {
    video = value;
    notifyListeners();
  }
}

class Player extends StatefulWidget {
  Player({super.key, required this.videoplayer});
  File videoplayer;
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late CachedVideoPlayerPlusController videocontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      videocontroller =
          CachedVideoPlayerPlusController.file(widget.videoplayer);
    });
    videocontroller.initialize();
    videocontroller.play();
    videocontroller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    videocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: CachedVideoPlayerPlus(videocontroller));
  }
}
