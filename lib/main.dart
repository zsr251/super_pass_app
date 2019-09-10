import 'package:flutter/material.dart';
import 'package:super_pass_app/widget/content_list.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContentList(),
    );
  }
}
