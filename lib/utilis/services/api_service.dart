import 'package:testapp/constants/api_path.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

final storage = FlutterSecureStorage();

Future<String> testGetData() async {
  Uri url = Uri.parse('$constantUrl/test/');

  //final token =
  //  'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNjMwNzE1MjU3fQ.iY-_UBE2NxlG5MTTtydWW01m1TGBOnMIGZfwG80Kjik';
  final token = await storage.read(key: 'token');

  var result = await http.get(url, headers: {
    'x-access-token': token.toString(),
    'Content-type': 'application/json'
  });
  print(result.body);
  return result.body.toString();
}

Future<Map> fetchData(urlEnding, data) async {
  Uri url = Uri.parse(constantUrl + urlEnding);
  var result = await http.post(url, body: data);
  if (result.statusCode != 200) {
    return json.decode(result.body);
  }
  return json.decode(result.body);
}
