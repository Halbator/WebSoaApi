/**
 * github Created by barre_k on 05/11/17.
 * Copyright (c) 2017, kevin barre. All rights reserved. Use of this source code
 * is governed by a BSD-style license that can be found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart' show parameter;
import 'package:image/image.dart' as readimg;

class ImageView extends StatefulWidget {
  @override
  _ImageViewState createState() => new _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  Map<String, dynamic> data;
  static final _header = {
    'Pragma': 'no-cache',
    'Origin': 'https://www.qwant.com',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'fr,en-US;q=0.9,en;q=0.8',
    'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.75 Safari/537.36',
    'Content-type': 'application/x-www-form-urlencoded',
    'Accept': '*/*',
    'Cache-Control': 'no-cache',
    'Referer': 'https://www.qwant.com/',
    'Connection': 'keep-alive',
    'DNT': '1'
  };

  static const String _url = "https://api.qwant.com/api/search/images?";

  Exception _handleError(dynamic e) {
    return new Exception('Server error; cause: $e');
  }

  Future getRequest(String params) async {
    try {
      print("parameter = $params");
      final response =
          await http.get(Uri.encodeFull("$_url$params"), headers: _header);
      print(response.body);
      print("\n\n\n\n\n\n\n");
      this.data = JSON.decode(response.body);
      print("end parse");
      data["data"]["result"]["items"].forEach((Map<String, dynamic> data) {
        print(data["media"]);
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future reload() async {
    List lol = new List();
    print("run reload");
    await this.getRequest("/count=1&q=$parameter");
    print("end request");
    for (var images in data["data"]["result"]["items"])
      {
        print(images["media"]);
        readimg.Image image = readimg.decodeImage(await http.readBytes(
            images["media"]));
        this.setState(() {
          lol.add(
              new Card(child: new Image.memory(readimg.encodePng(image)),));
        });
      }
    this.setState(() {
      patate = lol;
      print(lol);
      print(patate);
      print("end");
    });
  }

  List<Widget> patate = [];

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onLongPress: reload,
      child: new ListView(
        children: patate,
      ),
    );
  }
}