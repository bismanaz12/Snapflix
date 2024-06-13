import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/chatmodel.dart';
import 'package:social_app/myprofile.dart';
import 'package:voice_message_package/voice_message_package.dart';

class Bubble extends StatelessWidget {
  Bubble(
      {super.key,
      required this.time,
      required this.img,
      required this.txt,
      required this.name,
      required this.me,
      required this.type});
  bool me;
  String name;

  String img;
  String txt;
  messageType type;
  DateTime time;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return me
        ? Padding(
            padding: EdgeInsets.only(left: media.size.height * 0.06),
            child: type == messageType.text
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 22),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CircleAvatar(backgroundImage:NetworkImage(img),radius: 20,),
                            Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 16),
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(235, 35, 35, 65),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.elliptical(-30, 50),
                                          topLeft: Radius.circular(
                                              media.size.height * 0.02),
                                          bottomLeft: Radius.circular(
                                              media.size.height * 0.02),
                                          bottomRight: Radius.circular(
                                              media.size.height * 0.03),
                                        )),
                                    child: Text(
                                      txt,
                                      style: TextStyle(
                                          fontFamily: 'MyFont',
                                          color: Colors.white,
                                          fontSize: media.size.height * 0.02),
                                    ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: media.size.height * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${DateFormat('yyyy').format(time)}',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 200, 187, 187))),
                            Text('.',
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: media.size.height * 0.02,
                                    fontWeight: FontWeight.bold)),
                            Text('you',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 200, 187, 187)))
                          ],
                        ),
                      )
                    ],
                  )
                : type == messageType.video
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: PostPlayer(
                                      videoplayer: txt,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: media.size.height * 0.02),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('${time}',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 200, 187, 187))),
                                        Text('.',
                                            style: TextStyle(
                                                color: Colors.pink,
                                                fontSize:
                                                    media.size.height * 0.02,
                                                fontWeight: FontWeight.bold)),
                                        Text('you',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 200, 187, 187)))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : type == messageType.voice
                        ? VoiceMessageView(
                            activeSliderColor: Colors.black54,
                            controller: VoiceController(
                              audioSrc: txt,
                              maxDuration: const Duration(seconds: 60),
                              isFile: false,
                              onComplete: () {},
                              onPause: () {},
                              onPlaying: () {},
                              onError: (err) {},
                            ),
                          )
                        : Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          height: media.size.height * 0.2 * 1.2,
                                          child: Image.network(txt),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: media.size.height * 0.02),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text('${time}',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 200, 187, 187))),
                                              Text('.',
                                                  style: TextStyle(
                                                      color: Colors.pink,
                                                      fontSize:
                                                          media.size.height *
                                                              0.02,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('you',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 200, 187, 187)))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
        : Padding(
            padding: EdgeInsets.only(right: media.size.height * 0.06),
            child: type == messageType.text
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        //     margin: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 16),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(235, 35, 35, 65),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(-30, 50),
                                        topRight: Radius.circular(
                                            media.size.height * 0.02),
                                        bottomLeft: Radius.circular(
                                            media.size.height * 0.03),
                                        bottomRight: Radius.circular(
                                            media.size.height * 0.02),
                                      )),
                                  child: Text(
                                    txt,
                                    style: TextStyle(
                                        fontFamily: 'MyFont',
                                        color: Colors.white,
                                        fontSize: media.size.height * 0.02),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: media.size.height * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('${time}',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 200, 187, 187))),
                            Text('.',
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: media.size.height * 0.02,
                                    fontWeight: FontWeight.bold)),
                            Text('${name}',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 200, 187, 187)))
                          ],
                        ),
                      )
                    ],
                  )
                : type == messageType.video
                    ? Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          //     margin: const EdgeInsets.symmetric(vertical: 4),
                          alignment: Alignment.centerRight,

                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      child: PostPlayer(videoplayer: txt),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: media.size.height * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text('${time}',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 200, 187, 187))),
                                          Text('.',
                                              style: TextStyle(
                                                  color: Colors.pink,
                                                  fontSize:
                                                      media.size.height * 0.02,
                                                  fontWeight: FontWeight.bold)),
                                          Text('${name}',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 200, 187, 187)))
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                              ]),
                        ),
                      )
                    : type == messageType.voice
                        ? VoiceMessageView(
                            activeSliderColor: Colors.green,
                            controller: VoiceController(
                              audioSrc: txt,
                              maxDuration: const Duration(seconds: 60),
                              isFile: false,
                              onComplete: () {},
                              onPause: () {},
                              onPlaying: () {},
                              onError: (err) {},
                            ),
                          )
                        : Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              //     margin: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.centerRight,

                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          height: media.size.height * 0.2 * 1.2,
                                          child: Image.network(txt),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: media.size.height * 0.01),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${DateFormat('yyyy ddd').format(time)}',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 200, 187, 187))),
                                              Text('.',
                                                  style: TextStyle(
                                                      color: Colors.pink,
                                                      fontSize:
                                                          media.size.height *
                                                              0.02,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('${name}',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 200, 187, 187)))
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                                  ]),
                            ),
                          ));
  }
}
