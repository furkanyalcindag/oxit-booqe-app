import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:oxit_booqe_app/main.dart';

import 'package:oxit_booqe_app/posts_screen.dart';
import 'package:oxit_booqe_app/register_view/login.dart';
import 'package:oxit_booqe_app/services/auth_methods.dart';

import 'utils.dart';
import 'widgets.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/Menu.dart';

class NewsTabCopy extends StatefulWidget {
  static const title = 'Kategoriler';
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.news);

  @override
  _NewsTabCopyState createState() => _NewsTabCopyState();
}

class _NewsTabCopyState extends State<NewsTabCopy> {
  static const _itemsLength = 20;

  List<Color> colors;
  List<String> titles;
  List<String> contents;
  Future<List<Menu>> menus;
  //List<dynamic> menus = new List<dynamic>();

  List<Menu> parseMenu(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Menu>((json) => Menu.fromJson(json)).toList();
  }

  Future<List<Menu>> fetchMenu() async {
    String aToken = await storage.read(key: 'access');

    final response =
        await http.get(SERVER_IP + '/booqe/categories-api-get/', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $aToken',
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List jsonResponse = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      return jsonResponse.map((menu) => new Menu.fromJson(menu)).toList();

      //var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));

      //menus = data;
      //print(menus);
      //return 'Success';
    } else if (response.statusCode == 401) {
      AuthMethods authMethods = new AuthMethods();
      int status = await authMethods.refreshToken();

      if (status == 200) {
        fetchMenu();
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    menus = this.fetchMenu();
    //print(menus.length);
    colors = getRandomColors(_itemsLength);
    titles = List.generate(_itemsLength, (index) => generateRandomHeadline());
    contents =
        List.generate(_itemsLength, (index) => lorem(paragraphs: 1, words: 24));
    super.initState();
  }

  void refreshList() {
    // reload
    setState(() {
      menus = this.fetchMenu();
    });
  }

  void getPostsByCategory(int id) async {
    // reload
    print(id);
    String value = await storage.read(key: 'access');
    print(value);

    setState(() {
      menus = this.fetchMenu();
    });
    print(id);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostsScreen(categoryId: id.toString())),
    );
  }

  GridView _categoryList(data) {
    return GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 0.0, mainAxisSpacing: 0.0),
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
              onTap: () => this.getPostsByCategory(data[index].id),
              child: new Card(
                  child: Stack(
                children: <Widget>[
                  Image.network(data[index].categoryImage,
                      fit: BoxFit.fitWidth,
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      colorBlendMode: BlendMode.modulate),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        width: 348.0,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.4),
                        ),
                        child: Text(data[index].categoryName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            )),
                      )),
                ],
              )));
        });
  }

  Widget _gridBuilder(BuildContext context) {
    Paint paint = new Paint();
    paint.color = Colors.white;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: Container(
          color: Colors.white,
          child: FutureBuilder<List<Menu>>(
            future: fetchMenu(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Menu> data = snapshot.data;
                return _categoryList(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ));
  }

  // ===========================================================================
  // Non-shared code below because this tab uses different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    Paint paint = new Paint();
    paint.color = Colors.black26;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Booqe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              )),
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
          child: FutureBuilder<List<Menu>>(
            future: menus,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Menu> data = snapshot.data;
                return _categoryList(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget _buildIos(BuildContext context) {
    Paint paint = new Paint();
    paint.color = Colors.white;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("BOOQE"),
        ),
        child: Container(
          color: Colors.white,
          child: FutureBuilder<List<Menu>>(
            future: menus,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Menu> data = snapshot.data;
                return _categoryList(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return  Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          ),
        )
      );
            },
          ),
        ));
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
