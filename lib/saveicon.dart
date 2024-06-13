import 'package:flutter/material.dart';
import 'package:social_app/sharepref.dart';

class SavePost extends StatefulWidget {
  SavePost({super.key, required this.postId});
  String postId;

  @override
  State<SavePost> createState() => _SavePostState();
}

class _SavePostState extends State<SavePost> {
  bool save = false;

  @override
  void initState() {
    chcksave();
    super.initState();
  }

  chcksave() async {
    save = await Shreprefs().saved(widget.postId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return IconButton(
      onPressed: () {
        if (save) {
          Shreprefs().removeSave(widget.postId);
          setState(() {
            save = false;
          });
        } else {
          Shreprefs().addSave(widget.postId);
          setState(() {
            save = true;
          });
        }
      },
      icon: Icon(
        save ? Icons.bookmark : Icons.bookmark_border_outlined,
        color: Colors.white,
        size: media.size.height * 0.03 * 1.2,
      ),
    );
  }
}
