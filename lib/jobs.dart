/**
 * github Created by barre_k on 05/11/17.
 * Copyright (c) 2017, kevin barre. All rights reserved. Use of this source code
 * is governed by a BSD-style license that can be found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'main.dart' show parameter;

class JobsView extends StatefulWidget {
  @override
  _JobsViewState createState() => new _JobsViewState();
}

class _JobsViewState extends State<JobsView> {
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  List data;
  static const String _url =
      "https://jobs.github.com/positions.json?description=";

  Exception _handleError(dynamic e) {
    return new Exception('Server error; cause: $e');
  }

  Future getRequest(String params) async {
    try {
      final response = await get(Uri.encodeFull("$_url$params"));
      print(response.body);
      this.setState(() {
        this.data = JSON.decode(response.body);
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  void reload() {
    print("reload $parameter");
    this.getRequest("$parameter");
  }

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  initState() {
    super.initState();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: new Text("List Jobs")));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy?.cancel();
    _onUrlChanged?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onLongPress: reload,
      key: _scaffoldKey,
      child: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            print(data[index]["id"]);
            return new GestureDetector(
              onDoubleTap: () {_onPressed(data[index]["url"]);},
                child: new Card(
              child: new Column(
                children: <Widget>[
                  new Text("${data[index]["title"]}"),
                  new Text("${data[index]["location"]}"),
                  new Text("${data[index]["type"]}"),
                  new Text("${data[index]["created_at"]}"),
                  new Text("${data[index]["id"]}"),
                  new Text("${data[index]["url"]}"),
                ],
              ),
            ));
          }),
    );
  }

  void _onPressed(String url) {
    try {
      // This way you launch WebView with an url as a parameter.
      flutterWebviewPlugin.launch(url);
    } catch (e) {
      print(e);
    }
  }
}
