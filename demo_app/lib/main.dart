import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: Text("hello"),
          elevation: 0,
          backgroundColor: Colors.blueGrey,
          leading: Icon(Icons.menu),
          actions:[
            IconButton(onPressed: () {}, icon: Icon(Icons.logout))
          ]
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.green
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.green[400]
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green[200]
              ),
            ),
          ],
        )
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}