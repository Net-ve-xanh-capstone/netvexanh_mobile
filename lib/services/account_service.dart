import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netvexanh_mobile/models/refresh_token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:netvexanh_mobile/models/account.dart';

class AccountService {
  Future<bool> login(String username, String password) async {
    const url =
        'https://webapp-240702160733.azurewebsites.net/api/authentications/login';

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
        final refreshToken = RefreshToken.fromJson(jsonBody['refreshToken']);
        await save(jwtToken, refreshToken);
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

  Future<void> save(String jwtToken, RefreshToken refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    final token = jsonEncode(refreshToken.toJson());
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
    await prefs.setString('Id', decodedToken['Id']);
    await prefs.setString('name', decodedToken['nameid']);
    await prefs.setString('jwtToken', jwtToken);
    await prefs.setString('refreshToken', token);
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
