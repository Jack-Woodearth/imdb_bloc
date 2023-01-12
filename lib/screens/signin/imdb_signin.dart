import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/apis/apis.dart';
import 'package:imdb_bloc/beans/sign_in_user.dart';
import 'package:imdb_bloc/constants/config_constants.dart';
import 'package:imdb_bloc/cubit/user_cubit_cubit.dart';
import 'package:imdb_bloc/init.dart';
import 'package:imdb_bloc/screens/signin/cubit/sign_in_cubit.dart';
import 'package:imdb_bloc/singletons/user.dart';
import 'package:imdb_bloc/utils/dio/dio.dart';
import 'package:imdb_bloc/utils/string/string_utils.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../extensions/string_extensions.dart';

class ImdbSignInScreen extends StatefulWidget {
  const ImdbSignInScreen({super.key});

  @override
  State<ImdbSignInScreen> createState() => _ImdbSignInScreenState();
}

class _ImdbSignInScreenState extends State<ImdbSignInScreen> {
  // var username = 'imdb1';
  // var password = '123456dd';
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) =>
              SignInCubit()..set(username: 'imdb1', password: '123456dd'),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SignInInputs(),
                SignInButton(
                  formKey: formKey,
                ),
                // TextButton(
                //     onPressed: () {
                //       var validate = formKey.currentState?.validate();
                //       print('validate=$validate');
                //     },
                //     child: const Text('validate'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInInputs extends StatelessWidget {
  const SignInInputs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            TextFormField(
              initialValue: 'imdb1',
              validator: (value) => value?.isValidUsername() == true
                  ? null
                  : 'Username is invalid',
              // name: 'Username',
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: 'Username',
                // errorText: state.username.isValidUsername()
                //     ? null
                //     : 'Username is invalid'
              ),
              onChanged: (v) {
                // username = v;
                context.read<SignInCubit>().set(username: v);
              },
            ),
            TextFormField(
              initialValue: '123456dd',
              // name: 'Password',
              onChanged: (v) {
                // password = v;
                context.read<SignInCubit>().set(password: v);
              },
              validator: (v) =>
                  v?.isValidPassword() == true ? null : 'Password is invalid',
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                suffixIcon: Icon(
                  Icons.password,
                ),
              ),
            )
          ]
              .map((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: e,
                  ))
              .toList(),
        )
      ],
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
    required this.formKey,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          if (formKey.currentState?.validate() != true) {
            EasyLoading.showError('Username and/or password is invalid');
            return;
          }
          var of = GoRouter.of(context);
          var signInCubit = context.read<SignInCubit>();

          var userCubit = context.read<UserCubit>();
          // var favListCountCubit = context.read<FavListCountCubit>();
          //ddddd
          if (!signInCubit.state.username.isValidUsername() ||
              !signInCubit.state.password.isValidPassword()) {
            EasyLoading.showError('Username and/or password is invalid');
            return;
          }
          var response = await SignInApis.login(SignInUser(
              username: signInCubit.state.username,
              password: await encryptPwd(signInCubit.state.password)));
          // print(response.data);
          if (reqSuccess(response)) {
            EasyLoading.showSuccess('Sign in success');

            user = User(
                isLogin: true,
                uid: '${response.data['uid']}',
                username: signInCubit.state.username,
                token: response.data['mysitetoken']);
            userCubit.setUser(user);

            // getFavListsCount(favListCountCubit);
            initWithContext(context);
            // of.go('/');
            goHome(context);
            var sp = await SharedPreferences.getInstance();
            sp.setString(userObjKey, jsonEncode(user.toJson()));
          } else {
            EasyLoading.showError('${response.data['msg']}');
          }
        },
        child: const Text('Sign in'));
  }
}
