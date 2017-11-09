/**
 * github Created by barre_k on 05/11/17.
 * Copyright (c) 2017, kevin barre. All rights reserved. Use of this source code
 * is governed by a BSD-style license that can be found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WebView extends StatefulWidget {
  @override
  _WebViewState createState() => new _WebViewState();
}

class _WebViewState extends State<WebView> {
  Map<String, dynamic> data;
  static const String _url = "https://ifconfig.co/json";

  Exception _handleError(dynamic e) {
    return new Exception('Server error; cause: $e');
  }

  Future getRequest() async {
    try {
      final response =
      await http.get(Uri.encodeFull("$_url"));
      print(response.body);
      this.setState(() {
        this.data = JSON.decode(response.body);
      });
    } catch (e) {
      throw _handleError(e);
    }
  }
  void getIp()
  {
    this.getRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            new Text("Ip ${data == null ? "": data["ip"]}"),
            new Text("Country ${data == null ? "": data["country"]}"),
            new Text("Country ${data == null ? "": data["city"]}"),
            new RaisedButton(
              onPressed: getIp,
              child: new Text("Get Ip location"),
            )
          ],
      ),
    );
  }
}
