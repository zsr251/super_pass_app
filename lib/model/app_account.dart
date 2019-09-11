import 'package:json_annotation/json_annotation.dart';
import 'package:super_pass_app/common/encrypt_util.dart';

@JsonSerializable()
class AppAccount {
  final int id;
  final String icon;
  final String appName;
  final String showUserName;
  final String password;

  String getShowPassword(superPass) =>
      EncrypUtil.decryptedAES(password, superPass);

  AppAccount(
      this.id, this.icon, this.appName, this.showUserName, this.password);
}
