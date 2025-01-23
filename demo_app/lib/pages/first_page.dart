import 'package:demo_app/pages/home_page.dart';
import 'package:demo_app/pages/profile_page.dart';
import 'package:demo_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int selectedIndex = 0;

  void navigateBottomBar(int index)
  {
    setState(() {
      selectedIndex=index;     
    });
  }

  final List pages=[
    HomePage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Page"),
        backgroundColor: Colors.blue,
      ),
      body: pages[selectedIndex],
      drawer: Drawer(
        backgroundColor: Colors.purple[100],
        child: Column(
          children: [
            //drawer header place
            DrawerHeader(
              child: Icon(
                Icons.person,
                size: 64,
              )
            ),

            //List tile for home page
            ListTile(
              leading: Icon(Icons.home),
              title: Text("H O M E"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/homepage');
              },
            ),

            //List tile for profile
            ListTile(
              leading: Icon(Icons.person),
              title: Text('P R O F I L E'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profilepage');
              }
            ),

            //List tile for settings
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("S E T T I N G S"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settingspage');
              },
            )
          ]
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: navigateBottomBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings'
          )
        ]
      )
    );
  }
}