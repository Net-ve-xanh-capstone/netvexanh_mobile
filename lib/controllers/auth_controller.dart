import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netvexanh_mobile/models/account.dart';
import 'package:netvexanh_mobile/models/test_jwt.dart';

class AuthController {
  Future<Test?> login(String username, String password) async {
    final _url =
        'http://autocare.runasp.net/api/Accounts/Login?email=cs1&password=1';

    // var response = await http.post(Uri.parse(_url),
    //      body: {"email": username, "password": password});
    var response = await http.post(Uri.parse(_url));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Test.fromJson(json);
    } else {
      return null;
    }
  }
}
