import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final urlTrending =
    'https://api.giphy.com/v1/gifs/trending?api_key=wfCaDWTY5cyMHapDmXGpnXiKXWdLloKQ&limit=20&rating=G';
final urlSearch = '';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;

  @override
  void initState() {
    super.initState();

    this._getGifs();
  }

  _getGifs() async {
    final url = _search == null ? urlTrending : urlSearch;

    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
