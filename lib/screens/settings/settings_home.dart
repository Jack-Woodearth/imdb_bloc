import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imdb_bloc/widget_methods/widget_methods.dart';
import 'package:settings_ui/settings_ui.dart';

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
        ])
      ]),
    );
  }
}
