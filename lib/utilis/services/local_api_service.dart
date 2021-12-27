import 'package:testapp/constants/api_path.dart';
import 'package:testapp/utilis/get_file_path.dart';
import 'package:testapp/pages/home/home.dart';
import 'dart:io';

Future<List> loadPicturesFromCollection() async {
  Directory filePath = Directory(await getFilePath());

  filePath.listSync().forEach((element) {
    String str = (element.toString().split(" ")[1]);
    String path = str.replaceAll(RegExp(r"\'"), "");

    var contain = listLoadPicturesFromCollection.contains(path);

    if (!contain) {
      listLoadPicturesFromCollection.add(path);
    }
  });

  return listLoadPicturesFromCollection;
}
