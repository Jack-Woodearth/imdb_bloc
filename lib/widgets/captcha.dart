import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:imdb_bloc/apis/captcha.dart';

class CaptchaWidget extends StatefulWidget {
  const CaptchaWidget({super.key});

  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  Future<Captcha> future = getCaptchaApi();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: future,
          builder: (BuildContext context, snapshot) {
            return snapshot.data?.captcha == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Image.memory(base64Decode(snapshot.data!.captcha));
          },
        ),
        IconButton(
            onPressed: () {
              future = getCaptchaApi();
              setState(() {});
            },
            icon: Icon(Icons.refresh))
      ],
    );
  }
}
