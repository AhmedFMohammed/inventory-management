import 'package:http/http.dart' as http;
import 'dart:convert';

class APIHelper {
  String base_url = 'http://127.0.0.1:8000';
  Map<String, String> header = {
    'Content-Type': 'application/json; charset=UTF-8'
  };

  Future<http.Response?> get({required String path, int? Header}) async {
    http.Response responce;
    var url = Uri.parse("$base_url$path");
    responce = await http.get(url, headers: header);

    return responce;
  }

  Future<http.Response?> post(
      {required String path, required Object body, required int Header}) async {
    http.Response? responce;
    try {
      var url = Uri.parse("$base_url$path");
      print(json.encode(body));

      responce = await http.post(url, headers: header, body: json.encode(body));

      return responce;
    } catch (e) {
      print(e);
    }
    return responce;
  }

  Future<http.Response?> put(
      {required String path, required Object body, required int Header}) async {
    http.Response? responce;
    try {
      var url = Uri.parse("$base_url$path");

      responce = await http.put(url, headers: header, body: json.encode(body));

      return responce;
    } catch (e) {
      print(e);
    }
    return responce;
  }

  Future<http.Response?> delete(
      {required String path, required int Header}) async {
    http.Response? responce;
    try {
      var url = Uri.parse("$base_url$path");

      responce = await http.delete(url, headers: header);

      return responce;
    } catch (e) {
      print(e);
    }
    return responce;
  }
}
