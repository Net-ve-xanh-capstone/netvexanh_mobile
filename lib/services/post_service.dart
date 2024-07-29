import 'package:netvexanh_mobile/models/list_post.dart';
import 'package:netvexanh_mobile/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostService {
  static Future<Map<String, dynamic>> getPosts(int pageSize, int pageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String url = 'https://netvexanh.azurewebsites.net/api/posts';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final result = jsonBody['result'];
      final List<ListPost> posts =
          List<ListPost>.from(result['list'].map((json) => ListPost.fromJson(json)));
      return {
        'list': posts,
        'totalPage': result['totalPage']
      };
    } else {
      throw Exception('Failed to load posts');
    }
  }


  static Future<Post> getPostDetails(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String url = 'https://netvexanh.azurewebsites.net/api/posts/$id';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body)['result'];
      return Post.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load post details');
    }
  }
}
