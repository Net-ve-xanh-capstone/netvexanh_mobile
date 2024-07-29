import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netvexanh_mobile/models/schedule_award.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleAwardService {

  static Future<ScheduleAward> getScheduleAwardById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String url =
        'https://netvexanh.azurewebsites.net/api/awardschedules/$id';
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final result = jsonBody
        ['result'];
        final ScheduleAward schedule = ScheduleAward.fromJson(result);
        return schedule;
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      throw Exception('Failed to load schedule with id $id: $e');
    }
  }

}
