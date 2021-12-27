import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> getPictureFilePath(pictureName) async {
  Directory? appDocumentsDirectory = await getExternalStorageDirectory();
  String appDocumentsPath = appDocumentsDirectory!.path;
  String filePath = '$appDocumentsPath/$pictureName';

  return filePath;
}

Future<String> getFilePath() async {
  Directory? appDocumentsDirectory = await getExternalStorageDirectory();
  String appDocumentsPath = appDocumentsDirectory!.path;
  String filePath = '$appDocumentsPath/';

  return filePath;
}
