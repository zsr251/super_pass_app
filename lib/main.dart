import 'package:flutter/material.dart';
import 'package:super_pass_app/page/login.page.dart';
import 'package:super_pass_app/page/welcome_page.dart';
import 'package:super_pass_app/widget/content_list.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => WelcomePage(),
        '/home' : (context) => ContentList(),
        '/login' : (context) => LoginPage(),
      },
    );
  }
}
