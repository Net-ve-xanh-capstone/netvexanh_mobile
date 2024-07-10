import 'dart:convert';
import 'dart:ffi';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:netvexanh_mobile/models/schedule.dart';
import 'package:netvexanh_mobile/models/schedule_award.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleService {
  static const String baseUrl =
      'https://webapp-240702160733.azurewebsites.net/api/awardschedules';

  static Future<List<ScheduleAward>> getScheduleById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String url =
        'https://webapp-240702160733.azurewebsites.net/api/awardschedules/schedule/$id';
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
    String url = 'https://webapp-240702160733.azurewebsites.net/examiner/$id';
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

  Future<bool> postSelectedImages(String scheduleId, List<String> selectedIds, String rank) async {
    String url = 'https://webapp-240702160733.azurewebsites.net/api/schedules';

    if (rank == 'FirstPrize') {
      url = '$url/RatingFirstPrize';
    } else if (rank == 'SecondPrize') {
      url = '$url/RatingSecondPrize';
    } else if (rank == 'ThirdPrize') {
      url = '$url/RatingThirdPrize';
    } else if (rank == 'ConsolationPrize') {
      url = '$url/RatingConsolationPrize';
    } else {
      url = '$url/RatingPreliminaryRound';
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    String? id = prefs.getString('Id');

    // Tạo body của request
    final body = jsonEncode({
      'scheduleId': scheduleId,
      'paintings': selectedIds,
    });
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: body);

      if (response.statusCode == 200) {
        // Thành công
        print('Request successful'); 
        print(response.body);
        return true;
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
