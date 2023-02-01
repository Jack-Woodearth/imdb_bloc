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
import 'package:imdb_bloc/utils/debug_utils.dart';
import 'package:imdb_bloc/utils/dio/dio.dart';
import 'package:imdb_bloc/utils/string/string_utils.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:imdb_bloc/widgets/captcha.dart';
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
  final data = isDebug
      ? SignInData(
          username: 'imdb1', password: '123456dd', email: 'dusic1997@sina.com')
      : SignInData(username: '', password: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => SignInCubit(),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SignInInputs(
                  data: data,
                ),
                SignInButton(
                  data: data,
                  formKey: formKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInInputs extends StatefulWidget {
  const SignInInputs({
    Key? key,
    required this.data,
  }) : super(key: key);
  final SignInData data;
  @override
  State<SignInInputs> createState() => _SignInInputsState();
}

class _SignInInputsState extends State<SignInInputs> {
  var _showPassword = true;
  var _showPasswordConfirmation = true;
  late final data = widget.data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            TextFormField(
              initialValue: data.username,
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
                data.username = v;
                dp('data.username=${data.username}');
              },
            ),
            StatefulBuilder(builder: (context, update) {
              return TextFormField(
                initialValue: data.password,
                // name: 'Password',
                onChanged: (v) {
                  data.password = v;
                },
                validator: (v) =>
                    v?.isValidPassword() == true ? null : 'Password is invalid',
                obscureText: _showPassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: InkWell(
                    child: const Icon(
                      Icons.password,
                    ),
                    onTap: () {
                      update(
                        () {
                          _showPassword = !_showPassword;
                        },
                      );
                    },
                  ),
                ),
              );
            }),
            BlocBuilder<SignInCubit, SignInState>(
              builder: (context, state) {
                return AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: state.isLogin
                      ? const SizedBox()
                      : StatefulBuilder(builder: (context, update) {
                          return TextFormField(
                            initialValue: '',
                            onChanged: (v) {
                              data.passwordConfirmation = v;
                            },
                            validator: (v) => v == data.password
                                ? null
                                : 'Password confirmation does not match',
                            obscureText: _showPasswordConfirmation,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Password confirmation',
                              suffixIcon: InkWell(
                                child: const Icon(
                                  Icons.password,
                                ),
                                onTap: () {
                                  update(
                                    () {
                                      _showPasswordConfirmation =
                                          !_showPasswordConfirmation;
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                );
              },
            ),
            BlocBuilder<SignInCubit, SignInState>(builder: (context, state) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: state.isLogin
                    ? const SizedBox()
                    : StatefulBuilder(builder: (context, update) {
                        return TextFormField(
                          initialValue: data.email,
                          validator: (value) =>
                              isValidEmail(value) ? null : 'Email is invalid',
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.zero)),
                                    onPressed: isValidEmail(data.email)
                                        ? () async {
                                            await showDialog(
                                                context: context,
                                                builder: ((context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          'Input captcha'),
                                                      content: CaptchaWidget(
                                                        email: data.email ?? '',
                                                      ),
                                                    )));
                                          }
                                        : null,
                                    child: const Text('Send code'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.email,
                                  )
                                ],
                              ),
                            ),
                            border: const OutlineInputBorder(),
                            labelText: 'Email',
                            // suffix:
                          ),
                          onChanged: (v) {
                            update(() {
                              data.email = v;
                            });
                          },
                        );
                      }),
              );
            }),
            BlocBuilder<SignInCubit, SignInState>(builder: (context, state) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: state.isLogin
                    ? const SizedBox()
                    : TextFormField(
                        initialValue: '',
                        validator: (value) => notBlank(value)
                            ? null
                            : 'Email verification code is empty',
                        // name: 'Username',
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          labelText: 'Email verification code',
                        ),
                        onChanged: (v) {
                          data.verifyCode = v;
                        },
                      ),
              );
            })
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
    required this.data,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final SignInData data;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return Column(
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: state.isLogin
                        ? null
                        : MaterialStateColor.resolveWith(
                            (states) => Theme.of(context).cardColor)),
                onPressed: () async {
                  if (!state.isLogin) {
                    context.read<SignInCubit>().set(isLogin: true);
                    return;
                  }
                  if (formKey.currentState?.validate() != true) {
                    EasyLoading.showError(
                        'Username and/or password is invalid');
                    return;
                  }
                  dp('username=${data.username} password= ${data.password}');
                  var of = GoRouter.of(context);
                  var signInCubit = context.read<SignInCubit>();

                  var userCubit = context.read<UserCubit>();
                  // var favListCountCubit = context.read<FavListCountCubit>();
                  //ddddd
                  if (!data.username.isValidUsername() ||
                      !data.password.isValidPassword()) {
                    // EasyLoading.showError(
                    //     'Username and/or password is invalid');
                    return;
                  }
                  await signIn(context);
                },
                child: Text(
                  'Sign in',
                  style: TextStyle(color: state.isLogin ? null : Colors.grey),
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: !state.isLogin
                        ? null
                        : MaterialStateColor.resolveWith(
                            (states) => Theme.of(context).cardColor)),
                onPressed: () async {
                  if (state.isLogin) {
                    context.read<SignInCubit>().set(isLogin: false);

                    return;
                  }
                  if (formKey.currentState?.validate() != true) {
                    return;
                  }
                  var response = await SignInApis.register(SignInUser(
                      username: data.username,
                      password: data.password,
                      email: data.email,
                      emailCode: data.verifyCode));
                  if (reqSuccess(response)) {
                    EasyLoading.showSuccess('Sign up success');
                    await signIn(context);
                  } else {
                    EasyLoading.showError('$response');
                  }
                },
                child: Text('Sign up',
                    style:
                        TextStyle(color: !state.isLogin ? null : Colors.grey)))
          ],
        );
      },
    );
  }

  Future<void> signIn(BuildContext context) async {
    UserCubit userCubit = context.read<UserCubit>();
    var response = await SignInApis.login(SignInUser(
        username: data.username, password: await encryptPwd(data.password)));
    // print(response.data);
    if (reqSuccess(response)) {
      EasyLoading.showSuccess('Sign in success');

      user = User(
          isLogin: true,
          uid: '${response.data['uid']}',
          username: data.username,
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
  }
}
