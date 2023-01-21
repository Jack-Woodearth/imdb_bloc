import 'package:flutter/material.dart';

const isDebug = true;
const String serverDebug = 'http://192.168.42.48:18088';
const String server = 'https://cn-ah-dx-2.natfrp.cloud:58475';
const String serverCurrent = isDebug ? serverDebug : server;
const String userUrl = '$serverCurrent/api/v1/users';
const String baseUrl = '$serverCurrent/api/v1/imdb';
const String imdbHomeUrl = 'https://www.imdb.com';
const String defaultCover =
    'https://wx2.sinaimg.cn/mw2000/008sfaslly1h3eswxhosvj305t08iq2r.jpg';

const String defaultAvatar =
    'https://wx2.sinaimg.cn/mw2000/008sfaslgy1h4doahxsfmj30e80e8wez.jpg';

const tokenKey = 'mysitetoken1234564654564564';
const userObjKey = '121564564564654122';
final MID_PATTERN_EXACT = RegExp(r'tt\d+');
final PID_PATTERN_EXACT = RegExp(r'nm\d+');
final MID_OR_PID_PATTERN_EXACT = RegExp(r'^(nm\d+|tt\d+)$');

const transitionDuration = Duration(milliseconds: 300);
const double homeTitleHeight = 60;
const tinyTitle = TextStyle(fontSize: 13, fontWeight: FontWeight.w300);
