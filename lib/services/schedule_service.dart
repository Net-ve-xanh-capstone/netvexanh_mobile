import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netvexanh_mobile/models/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleService {
  static const String baseUrl =
      'https://webapp-240702160733.azurewebsites.net/api/schedules/';

  static Future<Schedule> getScheduleById(String id) async {
    final url =
        Uri.parse('$baseUrl/$id'); // URL endpoint lấy lịch trình theo ID

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        Schedule schedule = Schedule.fromJson(data);
        return schedule;
      } else {
        throw Exception('Failed to load schedule with id $id');
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

  Future<void> postSelectedImages(
      String testId, List<String> selectedIds) async {
    final url = Uri.parse('$baseUrl/RatingPreliminaryRound');

    // Tạo body của request
    final body = jsonEncode({
      'testId': testId,
      'paintings': selectedIds,
    });

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Thành công
        print('Request successful');
        print(response.body);
      } else {
        // Lỗi từ server
        print('Request failed with status: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Lỗi từ client
      print('Error sending request: $e');
    }
  }
}
