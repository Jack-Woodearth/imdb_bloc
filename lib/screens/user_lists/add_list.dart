import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/cubit/user_list_screen_filter_cubit.dart';

import '../../apis/user_lists.dart';
import '../../constants/config_constants.dart';
import '../../widgets/animated_text_field.dart';

class AddListScreen extends StatefulWidget {
  const AddListScreen({Key? key}) : super(key: key);

  @override
  State<AddListScreen> createState() => _AddListScreenState();
}

class _AddListScreenState extends State<AddListScreen> {
  String _type = 'Title';

  var _isPrivate = false;
  var description = '';
  var name = '';
  var isPublic = true;
  var isPeople = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedTextField(
              hint: 'List name',
              fontSize: 20,
              onChange: (v) {
                debugPrint('list name=$v');
                name = v;
              }),
          AnimatedTextField(
              hint: 'Description',
              fontSize: 15,
              onChange: (v) {
                debugPrint('description = $v');
                description = v;
              }),
          StatefulBuilder(
            builder: (BuildContext context, setStateInner) {
              return Row(
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Title',
                        groupValue: _type,
                        onChanged: (value) {
                          print(value);
                          setStateInner(() {
                            _type = 'Title';
                          });
                        },
                      ),
                      const Text('Title')
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                          value: 'Name',
                          groupValue: _type,
                          onChanged: (value) {
                            print(value);
                            setStateInner(() {
                              _type = 'Name';
                            });
                          }),
                      const Text('Name')
                    ],
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Private'),
                StatefulBuilder(
                  builder: (BuildContext context, setStateInner) {
                    return Switch(
                        value: _isPrivate,
                        onChanged: (value) {
                          setStateInner(() {
                            _isPrivate = value;
                          });
                        });
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton.filled(
                    onPressed: () async {
                      var cubit = context.read<UserListCubit>();

                      var route = GoRouter.of(context);

                      EasyLoading.show();
                      var res = await addUserListApi(
                        description,
                        name,
                        !_isPrivate,
                        _type == 'Name',
                      );
                      EasyLoading.dismiss();
                      if (res != null) {
                        EasyLoading.showSuccess(
                          'Successfully added a list',
                        );
                        route.pop();

                        (await Future.wait(
                            [Future.delayed(transitionDuration)]))[0];
                        cubit.addUserList(res);
                      } else {}
                    },
                    child: const Text('Save')),
              ),
            ),
          )
        ],
      ),
    );
  }
}
