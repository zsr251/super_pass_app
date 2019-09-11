import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:super_pass_app/common/api.dart';
import 'package:super_pass_app/common/config.dart';
import 'package:super_pass_app/common/encrypt_util.dart';
import 'package:super_pass_app/common/local_storage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormState>();
  // 用户名
  var _userName = "";
  // 用户登录密码
  var _password = "";
  // 用户超级密码
  var _superPass = "";
  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();
  final TextEditingController superController = new TextEditingController();

  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _superPass = await LocalStorage.get(Config.SUPER_PASS_KEY);

    userController.value = new TextEditingValue(text: _userName ?? "");
    superController.value = new TextEditingValue(text: _superPass ?? "");
  }

  @override
  void initState() {
    super.initState();
    initParams();
  }

  // 提交
  _submitLoginForm() {
    loginFormKey.currentState.save();
    if (!loginFormKey.currentState.validate()) {
      return;
    }
    _login();
  }

  // 登录
  _login() async {
    String S = EncrypUtil.generateMd5('$_superPass$_password');
    String bc = await Future(()=> EncrypUtil.bcrypt(S));
    final m = {
      'superPass': bc,
      'userName': _userName
    };
    String mjson = jsonEncode(m);
    Future<dynamic> res = httpManager.netFetch(
        '${API.BASE_URL}${API.LOGIN_PATH}',
        mjson,
        {"client": 3},
        Options(method: "post"));
    res.then((value) {
      print(value);
      // 成功
      if (value['c'] == '1') {
        LocalStorage.save(Config.SUPER_PASS_KEY, _superPass);
        LocalStorage.save(Config.USER_NAME_KEY, _userName);
        LocalStorage.save(Config.P_MD5_KEY, S);
        LocalStorage.save(Config.TOKEN_KEY, value['d']['token']);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // 失败
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('登录失败'),
                content: Text(value['m']),
              );
            });
      }
    });
  }

  String _valiateUserName(value) {
    print('valiate $value');
    if (value.isEmpty) {
      return 'user name is empty';
    }
    return null;
  }

  String _valiatePassword(value) {
    print('valiate $value');
    if (value.isEmpty) {
      return 'login password is empty';
    }
    return null;
  }

  String _valiateSuperPass(value) {
    print('valiate $value');
    if (value.isEmpty) {
      return 'super password is empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Form(
          key: loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                  onSaved: (value) {
                    _userName = value.trim();
                  },
                  validator: _valiateUserName,
                  controller: userController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_box),
                    labelText: '用户名',
                    helperText: '',
                    hintText: 'user name',
                  )),
              TextFormField(
                  onSaved: (value) {
                    _superPass = value.trim().toUpperCase();
                  },
                  validator: _valiateSuperPass,
                  controller: superController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.security),
                    labelText: '超级密钥',
                    helperText: '',
                    hintText: 'super pass',
                  )),
              TextFormField(
                  onSaved: (value) {
                    _password = value.trim();
                  },
                  obscureText: true,
                  validator: _valiatePassword,
                  controller: pwController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.keyboard),
                    labelText: '登录密码',
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
                    '登录',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _submitLoginForm,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
