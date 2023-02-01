import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/apis/apis.dart';
import 'package:imdb_bloc/apis/captcha.dart';

class CaptchaWidget extends StatefulWidget {
  const CaptchaWidget({
    super.key,
    required this.email,
  });
  final String email;
  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  late Future<Captcha?> future = getCaptcha();
  String captchaCode = '';
  String captchaId = '';
  Future<Captcha?> getCaptcha() async {
    final cap = await getCaptchaApi();
    captchaId = cap?.id ?? '';
    return cap;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder(
          future: getCaptcha(),
          builder: (BuildContext context, snapshot) {
            return snapshot.connectionState != ConnectionState.done
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.data?.captcha == null
                    ? const Text(
                        'Getting Captcha failed due to too frequent requests. Please wait a bit.',
                        style: TextStyle(color: Colors.red),
                      )
                    : Image.memory(base64Decode(snapshot.data!.captcha));
          },
        ),
        IconButton(
            onPressed: () {
              future = getCaptchaApi();
              setState(() {});
            },
            icon: const Icon(Icons.refresh)),
        Row(
          children: [
            const Expanded(
              child: SizedBox(),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) => captchaCode = value,
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
        TextButton(
            onPressed: () async {
              var emailCodeData = await SignInApis.getEmailCode(widget.email,
                  captchaCode: captchaCode, captchaId: captchaId);
              if (emailCodeData['code'] == 200) {
                EasyLoading.showSuccess('Email sent');
                GoRouter.of(context).pop();
              } else {
                EasyLoading.showError(emailCodeData['msg'].toString());
              }
            },
            child: const Text('Send email verification code'))
      ],
    );
  }
}
