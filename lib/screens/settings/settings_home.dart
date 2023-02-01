import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'methods_collections.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SettingsList(sections: [
        SettingsSection(tiles: [
          SettingsTile.navigation(
            title: const Text('Sign out'),
            onPressed: (context) {
              showConfirmDialog(context, 'Sign out', () async {
                logout(context);
                goHome(context);
              });
            },
          ),
          SettingsTile.navigation(
            title: const Text('Clear cache'),
            onPressed: (context) {
              showConfirmDialog(context, 'Clear all cache?', () {
                EasyLoading.show();
                SharedPreferences.getInstance().then((value) {
                  value.clear().then((value) {
                    EasyLoading.showSuccess('Cache cleared');

                    Navigator.of(context).pop();
                  });
                });
              });
            },
          )
        ])
      ]),
    );
  }
}
