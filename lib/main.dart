import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxit_booqe_app/profile.dart';

import 'package:oxit_booqe_app/settings_screen.dart';

import 'latest_posts.dart';
import 'songs_tab.dart';

import 'news_tab_copy.dart';
import 'profile_tab.dart';

import 'widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 


const SERVER_IP = 'http://192.168.1.37:8000';
final storage = FlutterSecureStorage();
void main() => runApp(MyAdaptingApp());

class MyAdaptingApp extends StatelessWidget {
  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    return MaterialApp(
      title: 'Adaptive Music App',
      theme: ThemeData(
        // Use the green theme for Material widgets.
        primarySwatch: Colors.red,
      ),
      builder: (context, child) {
        return CupertinoTheme(
          // Instead of letting Cupertino widgets auto-adapt to the Material
          // theme (which is green), this app will use a different theme
          // for Cupertino (which is blue by default).
          data: CupertinoThemeData(),
          child: Material(child: child),
        );
      },
      //home: LoginScreen(signup: false,),
      home: PlatformAdaptingHomePage(),
       /*routes: {
        "/": (context) => LoginScreen(signup: false),  //This is what you are missing i guess
        "/latest": (context) => LatestPostsScreen(),
        "/category": (context) => NewsTabCopy(),
        "/profile":(context)=>ProfileTwoPage(),
        "/settings":(context)=>SettingsOnePage()
      },*/
    );
  }
}

// Shows a different type of scaffold depending on the platform.
//
// This file has the most amount of non-sharable code since it behaves the most
// differently between the platforms.
//
// These differences are also subjective and have more than one 'right' answer
// depending on the app and content.
class PlatformAdaptingHomePage extends StatefulWidget {

  
  @override
  _PlatformAdaptingHomePageState createState() =>
      _PlatformAdaptingHomePageState();
}

class _PlatformAdaptingHomePageState extends State<PlatformAdaptingHomePage> {
  // This app keeps a global key for the songs tab because it owns a bunch of
  // data. Since changing platform re-parents those tabs into different
  // scaffolds, keeping a global key to it lets this app keep that tab's data as
  // the platform toggles.
  //
  // This isn't needed for apps that doesn't toggle platforms while running.
  final songsTabKey = GlobalKey();
  int currentTabIndex=0;

  List<Widget> tabs = [
    LatestPostsScreen(),
    NewsTabCopy(),
    ProfileTwoPage(),
    SettingsOnePage()
   
    
  ];

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  // In Material, this app uses the hamburger menu paradigm and flatly lists
  // all 4 possible tabs. This drawer is injected into the songs tab which is
  // actually building the scaffold around the drawer.
  Widget _buildAndroidHomePage(BuildContext context) {
    return Scaffold(
       
        // Body Where the content will be shown of each page index
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTabIndex,
            onTap: onTapped,
            items: [
               BottomNavigationBarItem(
                  icon: Icon(Icons.timeline , color: Color.fromRGBO(210, 74, 97, 1.0)),  title: Text("", style: TextStyle(color: Color.fromRGBO(250, 90, 141, 1.0))),),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu ,color: Color.fromRGBO(210, 74, 97, 1.0)), title: Text("",style: TextStyle(color: Color.fromRGBO(250, 90, 141, 1.0)))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person,color: Color.fromRGBO(210, 74, 97, 1.0)), title: Text("",style: TextStyle(color: Color.fromRGBO(250, 90, 141, 1.0)))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings,color: Color.fromRGBO(210, 74, 97, 1.0)), title: Text("",style: TextStyle(color: Color.fromRGBO(250, 90, 141, 1.0)))),
                   ]),
            
      );
  }

  // On iOS, the app uses a bottom tab paradigm. Here, each tab view sits inside
  // a tab in the tab scaffold. The tab scaffold also positions the tab bar
  // in a row at the bottom.
  //
  // An important thing to note is that while a Material Drawer can display a
  // large number of items, a tab bar cannot. To illustrate one way of adjusting
  // for this, the app folds its fourth tab (the settings page) into the
  // third tab. This is a common pattern on iOS.
  Widget _buildIosHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          
 BottomNavigationBarItem(
              title: Text(""), icon: Icon(Icons.timeline , color: Color.fromRGBO(210, 74, 97, 1.0)),  ),
          

          BottomNavigationBarItem(
              title: Text(""),icon: Icon(Icons.menu , color: Color.fromRGBO(210, 74, 97, 1.0)),),
          
          BottomNavigationBarItem(
              title: Text(""), icon: Icon(Icons.person , color: Color.fromRGBO(210, 74, 97, 1.0)),),
          BottomNavigationBarItem(
              title: Text(""), icon: Icon(Icons.settings , color: Color.fromRGBO(210, 74, 97, 1.0)),),
              ],


              /* 
               LatestPostsScreen(),
    NewsTabCopy(),
    ProfileTwoPage(),
    SettingsOnePage()
              */
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: SongsTab.title,
              builder: (context) => LatestPostsScreen(),
            );
          
          case 1:
            return CupertinoTabView(
              defaultTitle: ProfileTab.title,
              builder: (context) =>NewsTabCopy(),
            );

            case 2:
            return CupertinoTabView(
              defaultTitle: NewsTabCopy.title,
              builder: (context) =>ProfileTwoPage(),
            );

             case 3:
            return CupertinoTabView(
              defaultTitle: NewsTabCopy.title,
              builder: (context) =>  SettingsOnePage(),
            );
            
          default:
            assert(false, 'Unexpected tab');
            return null;
        }
      },
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroidHomePage,
      iosBuilder: _buildAndroidHomePage,
    );
  }
}

