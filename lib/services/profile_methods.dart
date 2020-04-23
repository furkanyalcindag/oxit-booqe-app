import 'dart:io';

import 'package:oxit_booqe_app/helper/database_user.dart';
import 'package:oxit_booqe_app/models/User.dart';

import '../main.dart';
import 'auth_methods.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileMethods {
  UserProvider databaseHelper = new UserProvider();

  Future<int> notificationSettings(bool val) async {
    String aToken = await storage.read(key: 'access');
    Map map = new Map();
    map['notification'] = val;

    final response =
        await http.post(SERVER_IP + '/booqe/profile-notification-api/',
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $aToken',
            },
            body: utf8.encode(json.encode(map)));

    if (response.statusCode == 200) {
      return 200;
    } else if (response.statusCode == 401) {
      AuthMethods authMethods = new AuthMethods();
      int status = await authMethods.refreshToken();

      if (status == 200) {
        notificationSettings(val);
        return 0;
      } else {
        //401 auth error
        return 401;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return 401;
    }
  }

  Future<int> uploadProfilePhoto(File image) async {
    String aToken = await storage.read(key: 'access');
    Map map = new Map();
    map['profileImage'] = image;

    final Map header = new Map();
    header['Authorization'] = 'Bearer $aToken';

    var uri = Uri.parse(SERVER_IP + '/booqe/change-profile-image/');
    var request = http.MultipartRequest('POST', uri)
      
      ..files.add(await http.MultipartFile.fromPath(
        'profileImage',
        image.path,
      ));
    request.headers['Authorization'] = 'Bearer $aToken';

    var response11 = await request.send();
    if (response11.statusCode == 200)
      return 200;
    else if (response11.statusCode == 401) {
      AuthMethods authMethods = new AuthMethods();
      int status = await authMethods.refreshToken();

      if (status == 200) {
        uploadProfilePhoto(image);
        return 0;
      } else {
        //401 auth error
        return 401;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return 401;
    }

    /* final response =
        await http.post(SERVER_IP + '/booqe/change-profile-image/', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $aToken',
    }, body: utf8.encode(json.encode(map)));

    if (response.statusCode == 200) {
      return 200;
    } else if (response.statusCode == 401) {
      AuthMethods authMethods = new AuthMethods();
      int status = await authMethods.refreshToken();

      if (status == 200) {
        uploadProfilePhoto(image);
        return 0;
      } else {
        //401 auth error
        return 401;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return 401;
    } */
  }

  Future<int> changePassword(String password) async {
    Future<User> user = databaseHelper.getUserAll();

    User user1 = new User();
    user.then((param) {
      user1.id = param.id;
      user1.username = param.username;
      user1.password = param.password;
    });
    String aToken = await storage.read(key: 'access');
    Map map = new Map();
    map['password'] = password;

    final response = await http.post(SERVER_IP + '/booqe/change-password/',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $aToken',
        },
        body: utf8.encode(json.encode(map)));

    if (response.statusCode == 200) {
      user1.password = password;
      await databaseHelper.update(user1);

      return 200;
    } else if (response.statusCode == 401) {
      AuthMethods authMethods = new AuthMethods();
      int status = await authMethods.refreshToken();

      if (status == 200) {
        changePassword(password);
        return 0;
      } else {
        //401 auth error
        return 401;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return 401;
    }
  }
}
