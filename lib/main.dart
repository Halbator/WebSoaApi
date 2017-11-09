import 'package:flutter/material.dart';
import './github.dart';
import './image.dart';
import './jobs.dart';
import './web.dart';

String parameter;

void main() {
  runApp(new MaterialApp(
    home: new TabView(),
  ));
}

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => new _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new TextField(
          onSubmitted: (String value) {
            parameter = value;
          },
        ),
        backgroundColor: Colors.redAccent,
        bottom: new TabBar(controller: this.controller, tabs: <Tab>[
          new Tab(text: "Github"),
          new Tab(text: "Image"),
          new Tab(text: "jobs"),
          new Tab(text: "Ip Info"),
        ]),
      ),
      body: new TabBarView(
        controller: this.controller,
        children: <Widget>[
          new GithubView(),
          new ImageView(),
          new JobsView(),
          new WebView(),
        ],
      ),
    );
  }
}
