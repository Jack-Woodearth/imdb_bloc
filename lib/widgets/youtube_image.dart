import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/config_constants.dart';
import '../utils/dio/dio.dart';
import '../utils/dio/mydio.dart';
import '../utils/string/string_utils.dart';

class YoutubeImage extends StatefulWidget {
  const YoutubeImage(
      {Key? key, required this.url, this.fit, this.useProxy = false})
      : super(key: key);
  final String url;
  @override
  State<YoutubeImage> createState() => _YoutubeImageState();
  final BoxFit? fit;
  final bool useProxy;
}

class _YoutubeImageState extends State<YoutubeImage> {
  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  @override
  void didUpdateWidget(covariant YoutubeImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _getImageUrl();
    }
  }

  String? imageUrl;
  _getImageUrl() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var spKey = 'proxy image url ${widget.url}';
    var local = sharedPreferences.getString(spKey);
    if (local != null) {
      imageUrl = local;
    } else {
      try {
        var resp = await MyDio().dio.get('$baseUrl/image', queryParameters: {
          'data': jsonEncode({'url': widget.url, 'use_proxy': widget.useProxy})
        });
        if (reqSuccess(resp)) {
          var data = resp.data['result'];
          if (data != null) {
            imageUrl = data;

            sharedPreferences.setString(spKey, imageUrl!);
          }
        }
      } catch (e) {
        // TODO
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('youtue image = $imageUrl');
    // print('imageUrl=$imageUrl');

    return Container(
        // color: Colors.black,
        child: isBlank(imageUrl)
            ? const Center(child: CircularProgressIndicator())
            // : MyNetworkImage(
            //     url: imageUrl!,
            //     fit: widget.fit ?? BoxFit.cover,
            //   ),
            : FutureBuilder<Response>(
                future: _getImageData(),
                builder:
                    (BuildContext context, AsyncSnapshot<Response> snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Image.memory(snapshot.data!.data);
                },
              ));
  }

  Future<Response<dynamic>> _getImageData() {
    if (isDebug) {
      imageUrl = imageUrl!.replaceAll(server, serverDebug);
    }
    return CacheDio()
        .dio
        .get(imageUrl!, options: Options(responseType: ResponseType.bytes));
  }
}
