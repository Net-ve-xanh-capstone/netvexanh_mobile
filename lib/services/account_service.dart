import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netvexanh_mobile/models/refresh_token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:netvexanh_mobile/models/account.dart';

class AccountService {
  Future<bool> login(String username, String password) async {
    const url =
        'https://netvexanh.azurewebsites.net/api/authentications/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final jsonBody = jsonDecode(response.body);
        final jwtToken = jsonBody['jwtToken'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
        var role = decodedToken['role'];
        if(role == 'Admin' || role == 'Staff') {
                print('This Role dont accept permission');
                return false;
        }
        await save(jwtToken);
        return true;
      } else {
        // Handle unsuccessful login
        print('Failed to login: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      return false;
      // Handle any errors that occur during the request
    }
  }

  Future<void> save(String jwtToken) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
    await prefs.setString('Id', decodedToken['Id']);
    await prefs.setString('name', decodedToken['nameid']);
    await prefs.setString('role', decodedToken['role']);
    await prefs.setString('jwtToken', jwtToken);
  }

  Future<Account?> loadAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final accountJson = prefs.getString('account');
    if (accountJson != null) {
      try {
        return Account.fromJson(jsonDecode(accountJson));
      } catch (error) {
        // Handle any errors that occur during JSON parsing
        print('Error loading account: $error');
        return null;
      }
    }
    return null; // Or handle this case as needed
  }
}
