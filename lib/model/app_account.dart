import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppAccount {
  final String icon;
  final String appName;
  final String showUserName;
  final String password;
  String get showPassword => password;
  AppAccount(this.icon, this.appName, this.showUserName, this.password);

}
