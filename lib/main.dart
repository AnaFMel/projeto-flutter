import 'package:flutter/material.dart';
import 'package:livraria_flutter/pages/bookListScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livraria Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}