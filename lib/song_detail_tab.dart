import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxit_booqe_app/profile.dart';
import 'package:oxit_booqe_app/register_view/login.dart';
import 'package:oxit_booqe_app/services/auth_methods.dart';

import 'main.dart';
import 'models/Post.dart';
import 'widgets.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Page shown when a card in the songs tab is tapped.
///
/// On Android, this page sits at the top of your app. On iOS, this page is on
/// top of the songs tab's content but is below the tab bar itself.
class ProfileDetail extends StatefulWidget {
  const ProfileDetail({this.id, this.song, this.color});

  final int id;
  final String song;
  final Color color;

  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  Future<List<Post>> posts;

  Future<List<Post>> fetchPost() async {
    String aToken = await storage.read(key: 'access');

    final response =
        await http.get(SERVER_IP + '/booqe/blogs-api-get-by-pin/', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $aToken',
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List jsonResponse = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      jsonResponse.map((post) => new Post.fromJson(post)).toList();
      return jsonResponse.map((post) => new Post.fromJson(post)).toList();
    } else if (response.statusCode == 401) {
      AuthMethods authMethods = new AuthMethods();
      int status = await authMethods.refreshToken();

      if (status == 200) {
        fetchPost();
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
      return null;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.

      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    posts = this.fetchPost();
    //print(menus.length);

    super.initState();
  }

  GridView _categoryList(data) {
    return GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 0.0, mainAxisSpacing: 0.0),
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
              onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileTwoPage()),
    ),
              child: new Card(
                  child: Stack(
                children: <Widget>[
                  Image.network(data[index].postImage,
                      fit: BoxFit.fitWidth,
                      color: Color.fromRGBO(255, 255, 255, 1),
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
                        child: Text('data[index].categoryName',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            )),
                      )),
                ],
              )));
        });
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: <Widget>[
              new Container(
                  margin: const EdgeInsets.only(bottom: 20,top: 10,left: 10),
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fitHeight,
                          
                          image: new NetworkImage(
                              "https://www.pembepanjur.com/blog/wp-content/uploads/2018/08/profilfotografi-800x655.jpg",))))
            ],
          ),
          Divider(
            height: 0,
            color: Colors.grey,
            
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: posts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Post> data = snapshot.data;
                  return _categoryList(data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Non-shared code below because we're using different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.song)),
      body: _buildBody(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.song),
        previousPageTitle: 'Songs',
      ),
      child: _buildBody(),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
