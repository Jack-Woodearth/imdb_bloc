import 'dart:io';
import 'package:encrypt/encrypt_io.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../../constants/config_constants.dart';
import '../../singletons/app_doc_path.dart';
import 'package:path/path.dart' as path;

import '../date_utils.dart';

makeIdsString(List<String> mids, String prefix, String sep) {
  if (mids.isEmpty) {
    return null;
  }
  var idsStr = '';

  for (var element in mids) {
    if (!element.startsWith(prefix)) {
      return null;
    }
    idsStr += element + sep;
  }
  idsStr = idsStr.substring(0, idsStr.lastIndexOf(sep));
  return idsStr;
}

bool isEmail(String s) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(s);
}

bool isBlank(String? s) {
  return s == null || s == '';
}

Future<String> encryptPwd(String pwd) async {
  final doc = AppDocPath().documentDirectory;
  final f = File(path.join(doc.path, 'pub.pem'));
  // var pub = f.readAsStringSync();
  // print(pub);
  final publicKey =
      await parseKeyFromFile<RSAPublicKey>(path.join(doc.path, 'pub.pem'));

  final plainText = pwd;
  final encrypter =
      Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP));
  final encrypted = encrypter.encrypt(plainText);
  // print(encrypted.base64);
  // print(encrypted.bytes);

  return encrypted.base64;
}

String bigPic(String url) {
  if (url == '') {
    return defaultCover;
  }
  if (url.lastIndexOf('.') == -1 ||
      !url.startsWith('https://m.media-amazon.com/images/') ||
      url.startsWith('https://m.media-amazon.com/images/S/sash/')) {
    return url;
  }

  // return url;
  // print('url: $url');
  if (!url.contains('_V1_')) {
    return url;
  }
  var full = url.substring(0, url.indexOf('_V1_'));
  var extension = url.substring(url.lastIndexOf('.'), url.length);
  var ret = '$full$extension';
  // print('big pic ret:$ret');
  return ret;
}

String smallPic(String url) {
  return url.replaceAll(RegExp(r'\._.*_\.'), '._V1_QL75_UY280_.');
}

String tinyPic(String url) {
  return url.replaceAll(RegExp(r'\._.*_\.'), '._V1_UY99_CR25,0,99,99_AL_.');
}

String capInitial(String? source) {
  if (source == null || source == '') {
    return '';
  }
  source = source.toLowerCase();
  return source[0].toUpperCase() + source.substring(1);
}

DateTime stringDateToDate(String dataStr) {
  try {
    var re = RegExp(r'([a-zA-Z]+)\s(\d+),\s(\d+)');

    var match = re.allMatches(dataStr).first;
    return DateTime(int.parse(match.group(3)!), monthToInt(match.group(1)!)!,
        int.parse(match.group(2)!));
  } catch (e) {
    return DateTime(2099);
  }
}

String handleYoutubeImage(String url) {
  if (url.contains('?')) {
    url = url.substring(0, url.indexOf('?'));
  }
  return url;
}

String pluralObjects(int count, String singular, [String? plural]) {
  plural ??= '${singular}s';
  return '$count ${count > 1 ? plural : singular}';
}

String capitalizeFirst(String str) {
  if (str == '') {
    return '';
  }
  return str[0].toUpperCase() + str.substring(1);
}

///capitalize all words separated by \s, _, or -
String capitalizeAll(String str) {
  if (str == '') {
    return '';
  }
  var regExp = RegExp(r'[\s_-]');
  final sep = regExp.firstMatch(str);
  if (sep == null) {
    return capitalizeFirst(str);
  }
  final sepStr = sep.group(0)!;
  return str.split(regExp).map((e) => capitalizeFirst(e)).join(sepStr);
}
