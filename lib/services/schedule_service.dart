import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netvexanh_mobile/models/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleService {
  static Future<List<Schedule>> getSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String? id = prefs.getString('Id');
    String url = 'https://webapp-240702160733.azurewebsites.net/examiner/$id';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final result = jsonBody['result'];
      final List<Schedule> schedules = List<Schedule>.from(result.map((json) => Schedule.fromJson(json)));
      return schedules;
    } else {
      throw Exception('Failed to load schedules');
    }
  }
}
