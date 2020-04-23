import 'package:http/http.dart' as http;
import 'package:oxit_booqe_app/helper/database_user.dart';
import 'package:oxit_booqe_app/main.dart';
import 'dart:convert';

import 'package:oxit_booqe_app/models/User.dart';

class AuthMethods {
  Future<int> logut() async {
    UserProvider databaseHelper = new UserProvider();

    await storage.delete(key: 'refresh');

    await storage.delete(key: 'access');

    Future<User> user = databaseHelper.getUserAll();

    User user1 = new User();
    user.then((param) {
      user1.id = param.id;
      user1.username = param.username;
      user1.password = param.password;
    });

    await databaseHelper.delete(user1.id);

    return 200;
  }

  Future<int> refreshToken() async {
    String refresh = await storage.read(key: 'refresh');

    if (refresh == null) {
      refresh = 'xxx';
    }

    final response = await http
        .post(SERVER_IP + '/api/token/refresh', body: {"refresh": refresh});

    if (response.statusCode == 401) {
      //error_code 100 => unvalid expiration
      return 100;
    } else if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      storage.write(key: "access", value: jsonResponse['access']);

      //error_code 200 => success
      return 200;
    } else {
      return 100;
    }
  }
}
