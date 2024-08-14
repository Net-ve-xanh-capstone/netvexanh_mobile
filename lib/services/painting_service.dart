import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netvexanh_mobile/models/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaintingService {
  
    static Future<List<Painting>> getScheduleById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String url =
        'https://netvexanh.azurewebsites.net/api/paintings/Schedule/$id';
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final result = jsonBody['result'];
        final List<Painting> paintings = List<Painting>.from(
            result.map((json) => Painting.fromJson(json)));
        return paintings;
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      throw Exception('Failed to load schedule with id $id: $e');
    }
  }

}
