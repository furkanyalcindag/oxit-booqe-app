import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oxit_booqe_app/register_view/login.dart';
import 'package:oxit_booqe_app/services/auth_methods.dart';
import 'package:oxit_booqe_app/single_post_screen.dart';

import 'package:oxit_booqe_app/widgets/network_image.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'models/Post.dart';
import 'models/Profile.dart';

class ProfileTwoPage extends StatefulWidget {
  static final String path = "lib/src/pages/profile/profile2.dart";

  @override
  _ProfileDetailState1 createState() => _ProfileDetailState1();
}

class _ProfileDetailState1 extends State<ProfileTwoPage> {
  Future<List<Post>> posts;

  Future<List<Profile>> profile;

  

  Future<List<Profile>> fetchProfile() async {
    String aToken = await storage.read(key: 'access');

    final response =
        await http.get(SERVER_IP + '/booqe/profile-info-api/', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $aToken',
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List jsonResponse = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      //jsonResponse.map((post) => new Post.fromJson(post)).toList();
      
      return  jsonResponse.map((profile) => new Profile.fromMap(profile)).toList();
    } else if (response.statusCode == 401) {
      AuthMethods authMethods = new AuthMethods();
      int status = await authMethods.refreshToken();

      if (status == 200) {
        fetchProfile();
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
    profile = this.fetchProfile();
    //print(menus.length);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.indigo.shade300, Colors.indigo.shade500]),
            ),
          ),
          Container(
          
          child:ListView.builder(
            itemCount: 7,
            itemBuilder: _mainListBuilder,
          )),
        ],
      ),
    );
  }

  Widget _mainListBuilder(BuildContext context, int index) {
    if (index == 0) return _buildHeader(context);
    if (index == 1) return _buildSectionHeader(context);
    if (index == 2) return _buildCollectionsRow();
    /*if(index==3) return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
      child: Text("Most liked posts",
        style: Theme.of(context).textTheme.title
      )
    );*/
    //return _buildListItem();
  }

  Widget _buildListItem() {
    return FutureBuilder<List<Profile>>(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Profile> data = snapshot.data;
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: PNetworkImage("http://192.168.1.34:8000/media/profile/66290479_1142666315927743_6906195828717649920_n.jpg", fit: BoxFit.cover),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
      /*    return Center(
            child: CircularProgressIndicator(),
          ); */
        });
  }

  Container _buildSectionHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Booqeler",
            style: Theme.of(context).textTheme.title,
          ),
          /*FlatButton(
            onPressed: () {},
            child: Text(
              "Create new",
              style: TextStyle(color: Colors.blue),
            ),
          ) */
        ],
      ),
    );
  }

  GridView _postList(data) {
    return GridView.builder(
        itemCount: data.length,
        
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 0.0, mainAxisSpacing: 0.0),
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SinglePostsScreen(blogId: data[index].id.toString())),
                  ),
              child: new Card(
                 
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    children: <Widget>[

                      Container(
                         decoration: BoxDecoration(
                        image: DecorationImage(
                        
                         image: data[index].postImage!=null? NetworkImage(data[index].postImage) :null,
                          fit: BoxFit.cover,
                         ))),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            width: 348.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                            ),
                            child: Text(data[index].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                )),
                          )),
                    ],
                  )));
        });
  }

  Container _buildCollectionsRow() {
    return Container(
        color: Colors.white,
        height: MediaQuery.of(context).copyWith().size.height / 2,
        
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: FutureBuilder<List<Post>>(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Post> data = snapshot.data;
                return _postList(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  Widget _buildHeader(BuildContext context) {
    return FutureBuilder<List<Profile>>(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Profile> data = snapshot.data;
            return Container(
              margin: EdgeInsets.only(top: 50.0),
              height: 240.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 5.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50.0,
                          ),
                          Text(
                            data[0].username,
                            style: Theme.of(context).textTheme.title,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text("UI/UX designer | Foodie | Kathmandu"),
                          SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            height: 40.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text("".toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12.0)),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      data[0].pinCount.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text("Booqey".toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12.0)),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text("".toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12.0)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        elevation: 5.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage:data[0].profileImage!=null?
                              CachedNetworkImageProvider(data[0].profileImage):null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          
          return Center(
            //child: CircularProgressIndicator(),
          );
        });
  }
}
