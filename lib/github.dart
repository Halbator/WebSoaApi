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

class GithubView extends StatefulWidget {
  GithubView({Key key}) : super(key: key);

  @override
  _GithubViewState createState() => new _GithubViewState();
}

class _GithubViewState extends State<GithubView> {
  Map<String, dynamic> data;
  static final _header = {
    "Authorization": "token 593cf805d6f8baf4503af935b01ee2c300f02d68",
    "Accept": "application/vnd.github.v3+json"
  };
  static const String _url = "https://api.github.com/search";

  Exception _handleError(dynamic e) {
    return new Exception('Server error; cause: $e');
  }

  Future getRequest(String params) async {
    try {
      final response =
          await http.get(Uri.encodeFull("$_url$params"), headers: _header);
      this.setState(() {
        this.data = JSON.decode(response.body);
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void reload() {
    print("reload");
    this.getRequest("/repositories?q=topic:$parameter");
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onLongPress: reload,
        child: new ListView.builder(
          itemCount: data == null ? 0 : data["items"].length,
          itemBuilder: (BuildContext context, int index) {
            print(data["items"][index]);
            print("\n\n");
            return new Card(
              child: new Column(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Text(
                        "ID : ${data["items"][index]["id"]}",
                        style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: 20.0,
                        ),
                      ),
                      new Text(
                        "${data["items"][index]["name"]}",
                        style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: 20.0,
                        ),
                      ),
                      new Text("${data["items"][index]["private"] == "false"
                          ? "Private"
                          : "Public"}"),
                    ],
                  ),
                  new Container(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text("Url ${data["items"][index]["html_url"]}"),
                        new Text(
                            "Description ${data["items"][index]["description"]}"),
                        new Text("Source ${data["items"][index]["url"]}"),
                        new Text(
                            "Language ${data["items"][index]["language"]}"),
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text("${data["items"][index]["owner"]["login"]}"),
                        new Text("Url creator github ${data["items"][index]["owner"]["url"]}"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
