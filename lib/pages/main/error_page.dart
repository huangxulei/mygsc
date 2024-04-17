import 'package:flutter/material.dart';

class ErrorApp extends StatelessWidget {
  final error;
  final stackTrace;
  const ErrorApp({this.error, this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            Text(
              "$error\n$stackTrace",
              style: TextStyle(color: Color(0xFFF56C6C)),
            )
          ],
        ),
      ),
    );
  }
}
