import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_pass_app/common/api.dart';
import 'package:super_pass_app/common/config.dart';
import 'package:super_pass_app/common/local_storage.dart';
import 'package:super_pass_app/model/app_account.dart';

class ContentList extends StatefulWidget {
  ContentList({Key key}) : super(key: key);

  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  String _token = '';
  String _superPass = '';
  int _currentPage = 0;
  int _totalPage = 0;
  int _pageSize = 20;
  List<AppAccount> _appAccountList = [];

  initParams() async {
    _token = await LocalStorage.get(Config.TOKEN_KEY);
    _superPass = await LocalStorage.get(Config.SUPER_PASS_KEY);
    if (_token == null ||
        _token.isEmpty ||
        _superPass == null ||
        _superPass.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
    }
    _nextPage();
  }
 // 下一页
  _nextPage(){
    if(_currentPage >= _totalPage && _totalPage > 0) {print('没有啦～');return;}
    _getContent(pageNum: _currentPage+1,pageSize: _pageSize);
  }
  _getContent({pageNum = 1, pageSize = 20}) async {
    Future<dynamic> res = httpManager.netFetch(
        '${API.BASE_URL}${API.APP_ACCOUNT_LIST_PATH}?pageNum=$pageNum&pageSize=$pageSize',
        {},
        {"client": 3,"token":_token},
        Options(method: "get"));
    res.then((value) {
      if (value['c'] == '1') {
          
          _currentPage = value['d']['pageNum'] as int;
          _totalPage = value['d']['totalPage'] as int;
           List<dynamic> list = value['d']['list'];
           setState(() {
            for (var item in list) {
              _appAccountList.add(AppAccount(item['id'],item['icon'],item['appName'],item['showUserName'],item['password']));
            }
           });
      }
      // 登录校验失败
      else if (value['c'] == '3') {
        LocalStorage.save(Config.P_MD5_KEY, '');
        LocalStorage.save(Config.TOKEN_KEY, '');
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _openSimpleDialog(value['m']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initParams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigration',
          onPressed: null,
        ),
        title: Text('super'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              _nextPage();
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _appAccountList.length,
        itemBuilder: _listItemBuilder,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.collections), title: Text('收藏')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), title: Text('账号')),
          BottomNavigationBarItem(
              icon: Icon(Icons.my_location), title: Text('设置')),
        ],
      ),
    );
  }

  _addItem() {
    setState(() {
      _appAccountList.add(AppAccount(1,'alipay', '支付宝', 'shengran', 'abcdef'));
    });
  }

  _openSimpleDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(text),
            children: <Widget>[],
          );
        });
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return ListTile(
      onTap: () => _addItem(),
      onLongPress: () {

        Clipboard.setData(
            new ClipboardData(text: _appAccountList[index].getShowPassword(_superPass)));
        _openSimpleDialog(_appAccountList[index].getShowPassword(_superPass));
      },
      leading: Icon(Icons.access_alarm),
      title: Text(_appAccountList[index].appName),
      subtitle: Text(_appAccountList[index].showUserName),
    );
  }
}
