import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netvexanh_mobile/models/painting_result.dart';
import 'package:netvexanh_mobile/models/schedule.dart';
import 'package:netvexanh_mobile/models/schedule_award.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleService {
  static const String baseUrl =
      'https://netvexanh.azurewebsites.net/api/awardschedules';

  static Future<List<ScheduleAward>> getScheduleById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String url =
        'https://netvexanh.azurewebsites.net/api/awardschedules/schedule/$id';
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final result = jsonBody['result'];
        final List<ScheduleAward> schedules = List<ScheduleAward>.from(
            result.map((json) => ScheduleAward.fromJson(json)));
        return schedules;
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      throw Exception('Failed to load schedule with id $id: $e');
    }
  }

  static Future<List<Schedule>> getSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String? id = prefs.getString('Id');
    String url = 'https://netvexanh.azurewebsites.net/api/schedules/examiners/$id';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final result = jsonBody['result'];
      final List<Schedule> schedules =
          List<Schedule>.from(result.map((json) => Schedule.fromJson(json)));
      return schedules;
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<bool> rating(String scheduleId, List<PaintingResult> result) async {
    String url = 'https://netvexanh.azurewebsites.net/api/schedules/Rating';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    prefs.getString('Id');

    // Tạo body của request
    final body = jsonEncode({'scheduleId': scheduleId, 'paintings': result});
    try {
      var response = await http.put(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: body);

      if (response.statusCode == 200) {
        // Send Confrm
        String confirmUrl =
            'https://netvexanh.azurewebsites.net/api/schedules/confirm-rating/$scheduleId';
        var responseV2 = await http.put(Uri.parse(confirmUrl), headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
        if (responseV2.statusCode == 200) {
          return true;
        }
        return false;
      } else {
        // Lỗi từ server
        print('Request failed with status: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      // Lỗi từ client
      print('Error sending request: $e');
      return false;
    }
  }
}
