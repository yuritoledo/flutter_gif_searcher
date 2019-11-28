import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Gif extends StatelessWidget {
  final _data;

  Gif(this._data);

  @override
  Widget build(BuildContext context) {
    final imageUrl = _data['images']['fixed_height']['url'];

    return Scaffold(
      appBar: AppBar(
        title: Text(_data['title']),
        backgroundColor: Colors.cyan,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(imageUrl);
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Image.network(imageUrl),
        ),
        color: Colors.black,
      ),
    );
  }
}
