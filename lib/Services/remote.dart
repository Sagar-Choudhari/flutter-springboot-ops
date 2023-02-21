import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/lang.dart';

const String baseUrl = 'http://192.168.1.42:8080/courses/';

class BaseClient {
  var client = http.Client();

  //GET
  Future<dynamic> get() async {
    var url = Uri.parse(baseUrl);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var json = response.body;
      return langFromJson(json);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  //POST
  Future<dynamic> post(dynamic object) async {
    var url = Uri.parse(baseUrl);
    var payLoad = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.post(url, body: payLoad, headers: headers);
    if (response.statusCode == 201) {
      var json = response.body;
      return langFromJson(json);
    } else {
      throw Exception('Failed to post data!');
    }
  }

  //PUT //UPDATE
  Future<dynamic> put(dynamic object) async {
    var url = Uri.parse(baseUrl);
    var payLoad = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.put(url, body: payLoad, headers: headers);
    // if (response.statusCode == 200) {
    //   var json = response.body;
    //   return langFromJson(json);
    // } else {
    //   throw Exception('Failed to update data!');
    // }

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['courses'];
      // return langFromJson(json);
      return data.map((course) => langFromJson(course)).toList();
    } else {
      throw Exception('Failed to update data!');
    }
  }

  //DELETE
  Future<dynamic> delete(id) async {
    var url = Uri.parse(baseUrl + id);
    var response = await client.delete(url);
    if (response.statusCode == 200) {
      var json = response.body;
      return langFromJson(json);
    } else {
      throw Exception('Failed to delete data!');
    }
  }
}
