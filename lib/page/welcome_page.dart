import 'package:flutter/material.dart';
import 'package:super_pass_app/common/config.dart';
import 'package:super_pass_app/common/encrypt_util.dart';
import 'package:super_pass_app/common/local_storage.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // 用户登录密码
  var _password = "";
  // 用户超级密码
  var _superPass = "";
  // 本地密码校验
  var _p = "";
  var _token = "";

  initParams() async {
    _token = await LocalStorage.get(Config.TOKEN_KEY);
    _p = await LocalStorage.get(Config.P_MD5_KEY);
    _superPass = await LocalStorage.get(Config.SUPER_PASS_KEY);
    if (_token == null ||
        _token.isEmpty ||
        _p == null ||
        _p.isEmpty ||
        _superPass == null ||
        _superPass.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    initParams();
  }

  // 解锁
  _doUnlock() {
    String p = EncrypUtil.generateMd5('$_superPass$_password');
    if (p == _p) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text('密码错误'),
              children: <Widget>[],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                onChanged: (value) {
                  _password = value.trim();
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.account_box),
                  labelText: '密码',
                  helperText: '',
                  hintText: 'password',
                )),
            SizedBox(
              height: 32.0,
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  '解锁',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _doUnlock,
              ),
            )
          ],
        ),
      ),
    );
  }
}
