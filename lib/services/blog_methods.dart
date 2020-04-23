import '../main.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'auth_methods.dart';

class BlogMethods {
  Future<int> pinBlog(int blogId) async {
    String aToken = await storage.read(key: 'access');
    Map map = new Map();
    map['blog_id'] = blogId;

    final response =
        await http.post(SERVER_IP + '/booqe/blogs-api-pin/', headers: {
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
        pinBlog(blogId);
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

  bool isTrueOrIsFalse(bool pin) {
    if (pin) {
      pin = false;
    } else {
      pin = true;
    }

    return pin;
  }
}
