import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_pass_app/model/app_account.dart';

class ContentList extends StatefulWidget {
  ContentList({Key key}) : super(key: key);

  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  List<AppAccount> _appAccountList = [
    AppAccount('weixin', '微信', 'zsr', '123456'),
    AppAccount('alipay', '支付宝', 'shengran', 'abcdef')
  ];

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
            onPressed:() => print('search'),
          )
        ],
      ),
      body: ListView.builder(
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
_openSimpleDialog(String text){
  showDialog(
    context: context,
    builder: (BuildContext context){
      return SimpleDialog(title: Text(text),
      children: <Widget>[],
      );
    }
  );
}
  Widget _listItemBuilder(BuildContext context, int index) {
    return ListTile(
      onLongPress: (){
        Clipboard.setData(new ClipboardData(text: _appAccountList[index].showPassword));
        _openSimpleDialog(_appAccountList[index].showPassword);
      },
      leading: Icon(Icons.access_alarm),
      title: Text(_appAccountList[index].appName),
      subtitle: Text(_appAccountList[index].showUserName),
    );
  }
}
