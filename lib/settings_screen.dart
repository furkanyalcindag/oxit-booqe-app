import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oxit_booqe_app/register_view/login.dart';
import 'package:oxit_booqe_app/services/auth_methods.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oxit_booqe_app/services/profile_methods.dart';

import 'change_password_screen.dart';
import 'main.dart';
import 'models/Profile.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class SettingsOnePage extends StatefulWidget {
  static final String path = "lib/src/pages/settings/settings1.dart";

  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  bool _dark;

  ProfileMethods profileMethods = new ProfileMethods();
  AuthMethods authMethods = new AuthMethods();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<List<Profile>> profile;

  File _image;
// This funcion will helps you to pick and Image from Gallery
  _pickImageFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });

    int status = await profileMethods.uploadProfilePhoto(_image);

    if (status == 200) {
      final snackBar = SnackBar(
        content: Text('Profil fotoğrafınız başarıyla güncellendi'),
        backgroundColor: Color.fromRGBO(210, 74, 97, 1),
      );

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      _scaffoldKey.currentState.showSnackBar(snackBar);
      

      setState(() {
         profile = this.fetchProfile();
      });
     
    }
  }

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

      return jsonResponse
          .map((profile) => new Profile.fromMap(profile))
          .toList();
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

  @override
  void initState() {
    super.initState();
    profile = this.fetchProfile();
    _dark = false;
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  Widget _buildSettings(BuildContext context) {
    return FutureBuilder<List<Profile>>(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Profile> data = snapshot.data;

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Color.fromRGBO(210, 74, 97, 1),
                        child: ListTile(
                          onTap: () {
                            //open edit profile
                          },
                          title: Text(
                            data[0].username,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media'),
                          ),
                          trailing: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Card(
                        elevation: 4.0,
                        margin:
                            const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.lock_outline,
                                color: Colors.purple,
                              ),
                              title: Text("Change Password"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                print("sdksds");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangePassword()));
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              leading: Icon(
                                FontAwesomeIcons.language,
                                color: Colors.purple,
                              ),
                              title: Text("Change Language"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                //open change language
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.purple,
                              ),
                              title: Text("Change Location"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                //open change location
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "Bildirim Ayarları",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: data[0].notification,
                        title: Text("Bildirim"),
                        onChanged: (val) {},
                      ),
                      SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: false,
                        title: Text("Received newsletter"),
                        onChanged: null,
                      ),
                      SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: true,
                        title: Text("Received Offer Notification"),
                        onChanged: (val) {},
                      ),
                      SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: true,
                        title: Text("Received App Updates"),
                        onChanged: null,
                      ),
                      const SizedBox(height: 60.0),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 00,
                  left: 00,
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.powerOff,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      //log out
                    },
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
              //child: CircularProgressIndicator(),
              );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      isMaterialAppTheme: true,
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: _dark ? null : Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Ayarlar',
            style: TextStyle(color: _dark ? Colors.white : Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.moon),
              onPressed: () {
                setState(() {
                  _dark = !_dark;
                });
              },
            )
          ],
        ),
        body: FutureBuilder<List<Profile>>(
            future: profile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Profile> data = snapshot.data;

                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Color.fromRGBO(210, 74, 97, 1),
                            child: ListTile(
                              onTap: () {
                                _pickImageFromGallery();
                              },
                              title: Text(
                                data[0].username,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: data[0].profileImage != null ? CachedNetworkImageProvider(
                                    data[0].profileImage):null
                              ),
                              trailing: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.fromLTRB(
                                32.0, 8.0, 32.0, 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(
                                    Icons.lock_outline,
                                    color: Color.fromRGBO(210, 74, 97, 1),
                                  ),
                                  title: Text("Şifre Değiştirme"),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () {
                                    //open change password
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePassword()));
                                  },
                                ),
                                _buildDivider(),
                                /*  ListTile(
                              leading: Icon(
                                FontAwesomeIcons.language,
                                color: Colors.purple,
                              ),
                              title: Text("Change Language"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                //open change language
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.purple,
                              ),
                              title: Text("Change Location"),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                //open change location
                              },
                            ),*/
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            "Bildirim Ayarları",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          SwitchListTile(
                            activeColor: Color.fromRGBO(210, 74, 97, 1),
                            contentPadding: const EdgeInsets.all(0),
                            value: data[0].notification,
                            title: Text('Bildirimler'),
                            onChanged: (val) async {
                              int status = await profileMethods
                                  .notificationSettings(val);

                              if (status == 200) {
                                setState(() {});
                              }
                            },
                          ),
                          /*SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: false,
                        title: Text("Received newsletter"),
                        onChanged: null,
                      ),
                      SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: true,
                        title: Text("Received Offer Notification"),
                        onChanged: (val) {},
                      ),
                      SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: true,
                        title: Text("Received App Updates"),
                        onChanged: null,
                      ),*/
                          const SizedBox(height: 60.0),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(210, 74, 97, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 00,
                      left: 00,
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.powerOff,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          //log out


                         int status= await authMethods.logut();
                         if(status==200){



                            Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                         }


                        },
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Center(
                  //child: CircularProgressIndicator(),
                  );
            }),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
