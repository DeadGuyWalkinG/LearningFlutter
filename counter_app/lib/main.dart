import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  int count=0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
      backgroundColor: Colors.purple[200],
      body: Center(
        child: GestureDetector(
          onTap: () {
            count++;
            print("circle clicked");
          },
          child: Container(
            width:200,
            height:200,
            decoration: BoxDecoration(
              color: Colors.purple[300],
              shape: BoxShape.circle
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 64,
                  color: Colors.black87,
                  fontFamily: 
                )
              ),
            )
          ),
        ),
      )
    )
    );
  }
}