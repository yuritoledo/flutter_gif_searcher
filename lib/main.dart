import 'package:flutter/material.dart';
import 'package:gif_search/ui/home.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
          hintColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
      home: Home(),
    ));
