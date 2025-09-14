import 'dart:convert';

import 'package:story_app/data/model/response_detail_story.dart';
import 'package:story_app/data/model/response_login.dart';
import 'package:story_app/data/model/response_new_story.dart';
import 'package:story_app/data/model/response_register.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/data/model/response_story.dart';

class ApiServices {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  Future<ResponseRegister> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/register"),
      body: {'name': name, 'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return ResponseRegister.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<ResponseLogin> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return ResponseLogin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login user');
    }
  }

  Future<ResponseStory> loadAll(int page, int size, String token) async {
    final uri = Uri.parse("$_baseUrl/stories").replace(
      queryParameters: {
        "page": page.toString(),
        "size": size.toString(),
        "location": "1",
      },
    );
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return ResponseStory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load story');
    }
  }

  Future<ResponseNewStory> newStory(
    String filePath,
    String description,
    String token,
    String latitude,
    String longitude,
  ) async {
    final uri = Uri.parse("$_baseUrl/stories");

    var request = http.MultipartRequest("POST", uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;
    request.fields['lat'] = latitude;
    request.fields['lon'] = longitude;

    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        filePath,
        filename: filePath.split('/').last,
      ),
    );

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    if (response.statusCode == 200) {
      return ResponseNewStory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load create story');
    }
  }

  Future<ResponseDetailStory> loadDetail(String id, String token) async {
    final uri = Uri.parse("$_baseUrl/stories/$id");
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return ResponseDetailStory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load detail story');
    }
  }
}
