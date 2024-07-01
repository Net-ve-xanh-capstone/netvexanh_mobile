import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netvexanh_mobile/services/account1.dart';

class AccountService {
  static Future<List<Account1>> fetchAccounts() async {
    final url = 'https://randomuser.me/api/?results=10';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final results = jsonBody['results'] as List;

      return results.map((json) => Account1.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load accounts');
    }
  }
}