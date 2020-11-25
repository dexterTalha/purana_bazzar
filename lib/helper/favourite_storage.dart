import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import '../models/ad_model.dart';

class FavoritesStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/myfavorites.dat');
  }

  Future<bool> writeFavorites(List<AdModel> favoritesList) async {
    try {
      final file = await _localFile;

      // Read the file
      String json =  jsonEncode(favoritesList);
      await file.writeAsString(json, mode: FileMode.write);

      return true;

    } catch (e) {
      print('error $e');
    }

    return false;
  }

  Future<List<AdModel>> readFavorites() async {
    List<AdModel> favs = [];
    try {
      final file = await _localFile;

      // Read the file
      String jsonString = await file.readAsString();

      Iterable jsonMap = jsonDecode(jsonString);

      favs = jsonMap.map((parsedJson) => AdModel.fromJson(parsedJson)).toList();

      return favs;

    } catch (e) {
      print('error : ${e.toString()}');
    }

    return favs;
  }
}