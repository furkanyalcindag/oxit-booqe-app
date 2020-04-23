import 'package:flutter/material.dart';

import 'package:flutter_login/flutter_login.dart';

import 'package:http/http.dart' as http;

import 'package:oxit_booqe_app/helper/database_user.dart';

import 'package:oxit_booqe_app/main.dart';
import 'package:oxit_booqe_app/models/User.dart';
import 'dart:convert';

import 'package:oxit_booqe_app/services/auth_methods.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



class LoginScreen extends StatefulWidget {
  final bool signup;
  LoginScreen({Key key, this.signup}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: 2250);
  UserProvider databaseHelper = new UserProvider();
  bool isLogin = true;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //BuildContext _scaffoldContext;

  Future<String> _authUser(data) async {
    AuthMethods authMethods = new AuthMethods();
    int status = await authMethods.refreshToken();

    if (status == 200) {
      return null;
    }

    final response = await http.post(SERVER_IP + '/api/token/',
        body: {"username": data.name, "password": data.password});

    return Future.delayed(loginTime).then((_) {
      if (response.statusCode == 200) {
        var jsonResponse =
            jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        storage.write(key: "access", value: jsonResponse['access']);
        storage.write(key: "refresh", value: jsonResponse['refresh']);
        storage.write(key: "add", value: "1");
        storage.write(key: "mainAdd", value: "0");

        User user = new User();
        user.username = data.name;
        user.password = data.password;

        databaseHelper.insert(user);

        return null;
      } else {
        return 'Password does not match';
      }
    });
  }

  Future<String> signupUser(data) async {
    String token = await _firebaseMessaging.getToken();
    final response = await http.post(SERVER_IP + '/booqe/register-api/', body: {
      "username": data.name,
      "password": data.password,
      'gcm_registerID': token
    });

    if (response.statusCode == 201) {
      final response = await http.post(SERVER_IP + '/api/token/',
          body: {"username": data.name, "password": data.password});

      return Future.delayed(loginTime).then((_) {
        if (response.statusCode == 200) {
          var jsonResponse =
              jsonDecode(Utf8Decoder().convert(response.bodyBytes));
          storage.write(key: "access", value: jsonResponse['access']);
          storage.write(key: "refresh", value: jsonResponse['refresh']);
          storage.write(key: 'add', value: '1');
          storage.write(key: 'mainAdd', value: '0');

          User user = new User();
          user.username = data.name;
          user.password = data.password;

          databaseHelper.insert(user);

          return null;
        } else {
          return 'Password does not match';
        }
      });
    } else {
      return 'Geçerli bir email adresi girdiğinizden emin olunuz.';
    }
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<void> loginControl() async {
    AuthMethods authMethods = new AuthMethods();
    int status = await authMethods.refreshToken();
    Future<User> user = databaseHelper.getUserAll();
    User user1 = new User();
    user.then((param) {
      user1.id = param.id;
      user1.username = param.username;
      user1.password = param.password;
    });

    if (status == 200) {
      String addValue = await storage.read(key: "mainAdd");
      if (addValue == null) {
        storage.write(key: 'add', value: '1');
        storage.write(key: 'mainAdd', value: '0');
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PlatformAdaptingHomePage(),
      ));
    } else if (status == 100 && user1.id != null) {
      final response = await http.post(SERVER_IP + '/api/token/',
          body: {"username": user1.username, "password": user1.password});

      if (response.statusCode == 200) {
        var jsonResponse =
            jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        storage.write(key: "access", value: jsonResponse['access']);
        storage.write(key: "refresh", value: jsonResponse['refresh']);
        storage.write(key: 'add', value: '1');
        storage.write(key: 'mainAdd', value: '0');

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => PlatformAdaptingHomePage(),
        ));
      } else {
        await databaseHelper.delete(user1.id);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      }
    } else {}
  }

  @override
  void initState() {
   
    super.initState();

    loginControl();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterLogin(
      title: '',
      logo: 'build/assets/icons/strawberry_color.png',
      onLogin: _authUser,
      onSignup: signupUser,
      onSubmitAnimationCompleted: () {
        if (isLogin) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => PlatformAdaptingHomePage(),
          ));
        } else {
          print(isLogin);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginScreen(signup: true),
          ));
        }
      },
      onRecoverPassword: _recoverPassword,
    ));
  }
}
