import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController {
  Future login(String username, String password) async {
    final _url = 'http://autocare.runasp.net/api/Accounts/Login?email=di%40gmail.com&password=1';

    // var response = await http.post(Uri.parse(_url),
    //      body: {"email": username, "password": password});
    var response = await http.post(Uri.parse(_url));
    if(response.statusCode == 200){
      var json = jsonDecode(response.body);
      print("test");
      print(json);
    }
    else{
      print("Login Error");
    }
  }


}
