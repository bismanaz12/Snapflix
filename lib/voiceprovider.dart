import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class voiceprovider with ChangeNotifier {
  bool isRecording = false;
  File? voiceChat;

  setRecording(bool value) {
    isRecording = value;
    notifyListeners();
  }

  Future record() async {
    if (!isRecorderReady) return;
    setRecording(true);
    await recoder.startRecorder(toFile: 'audio');
  }

  Future<void> stop() async {
    if (!isRecorderReady) return;
    final path = await recoder.stopRecorder();
    debugPrint('File path: $path');
    voiceChat = File(path!);

    notifyListeners();
    setRecording(false);
    // await uploadAudioToFirebase(file, user, group, postData, commentUser);
  }

  FlutterSoundRecorder recoder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  // start() async {
  //   await record.;
  // }
  Future initRecoder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recoder.openRecorder();
    isRecorderReady = true;
    recoder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }
}
