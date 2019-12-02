import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif_search/ui/gif.dart';
import 'package:http/http.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int _offset = 0;

  @override
  void initState() {
    super.initState();

    _getGifs();
  }

  _getGifs() async {
    String url;

    if (_search == null || _search.isEmpty) {
      final urlTrending =
          'https://api.giphy.com/v1/gifs/trending?api_key=wfCaDWTY5cyMHapDmXGpnXiKXWdLloKQ&limit=20&rating=G';
      url = urlTrending;
    } else {
      final urlSearch =
          'https://api.giphy.com/v1/gifs/search?api_key=wfCaDWTY5cyMHapDmXGpnXiKXWdLloKQ&q=$_search&limit=25&offset=$_offset&rating=G&lang=en';
      url = urlSearch;
    }

    Response response = await get(url);
    return jsonDecode(response.body);
  }

  _getListLength(List data) {
    final length = _search == null ? data.length : data.length + 1;
    return length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif',
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.black,
        child: Column(
          children: <Widget>[
            _searchInput(),
            Expanded(
              child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) return Container();

                    return _gifBuilder(context, snapshot);
                  }
                  return Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _searchInput() {
    return TextField(
      onSubmitted: (text) => setState(() {
        _search = text;
        _offset = 0;
      }),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: 'Busque aqui',
        labelStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white, fontSize: 18.0),
    );
  }

  Widget _gifBuilder(BuildContext context, AsyncSnapshot snapshot) {
    final list = List.from(snapshot.data['data']);
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: _getListLength(list),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemBuilder: (context, index) {
        if (_search == null || index < list.length) {
          final _imageUrl = list[index]['images']['fixed_height']['url'];
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              image: _imageUrl,
              placeholder: kTransparentImage,
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              print(list[index]);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Gif(list[index])));
            },
            onLongPress: () => Share.share(_imageUrl),
          );
        } else {
          return GestureDetector(
            onTap: () => setState(() => _offset += 19),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.add,
                  size: 28.0,
                ),
                Text(
                  'Carregar mais',
                )
              ],
            ),
          );
        }
      },
    );
  }
}
