// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:netvexanh_mobile/models/account.dart';

// class AccountService {
//   static Future<List<Account>> fetchUsers() async {
//     final url = 'https://randomuser.me/api/?results=10';
//     final uri = Uri.parse(url);
//     final response = await http.get(uri);
//     final body = response.body;
//     final json = jsonDecode(body);
//     final result = json['results'] as List<dynamic>;
//     final accounts = result.map((e) {
//       return Account.fromJson(e as Map<String, dynamic>);
//     }).toList();
//     return accounts;
//   }
// }
