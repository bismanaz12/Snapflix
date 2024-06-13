import 'package:shared_preferences/shared_preferences.dart';

class Shreprefs {
  String key = 'key';

  Future<void> addSave(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> saves = prefs.getStringList(key) ?? [];
    saves.add(postId);
    await prefs.setStringList(key, saves);
  }

  Future<void> removeSave(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> saves = prefs.getStringList(key) ?? [];
    saves.remove(postId);
    await prefs.setStringList(key, saves);
  }

  Future<List<String>> getAllSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<bool> saved(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saves = prefs.getStringList(key) ?? [];

    return saves.contains(postId);
  }
}
