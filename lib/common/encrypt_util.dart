import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:dbcrypt/dbcrypt.dart';

class EncrypUtil {
  // md5 加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

// bcrypt 加密
 static String bcrypt(String data) {
    String salt = new DBCrypt().gensaltWithRounds(10);
    return new DBCrypt().hashpw(data,salt);
 }

// aes128-ecb 加密
 static String encryptAES(String data, String pass) {
    assert(data != null);
    assert(pass != null);
    final key = Key.fromUtf8(pass.replaceAll('-', ''));
    final encrypter = Encrypter(AES(key,mode: AESMode.ecb));
    // final iv = IV.fromLength(16);
    final encrypted = encrypter.encrypt(data);
    return encrypted.base16;
  }

// aes128-ecb 解密
 static String decryptedAES(String data, String pass) {
    assert(data != null);
    assert(pass != null);
    final key = Key.fromUtf8(pass.replaceAll('-', ''));
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));

    final encrypted = Encrypted.fromBase16(data);
    return encrypter.decrypt(encrypted);
  }
}
