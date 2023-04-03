import 'package:flutter/material.dart';
import '../screens/drawer/iedata.dart';

import './footer.dart';
import './list_tile.dart';
import './header.dart';

import '../screens/drawer/help_screen.dart';
import '../screens/drawer/settings_screen.dart';
import '../screens/topics_panel/topic_panel.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(38, 82, 203, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppDrawerHeader(),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              AppDrawerListTile(
                icon: Icons.format_list_bulleted_rounded,
                title: 'Topics Panel',
                screen: TopicPanelScreen.routeName,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              AppDrawerListTile(
                icon: Icons.expand,
                title: 'Import/Export Data',
                screen: ImportExportScreen.routeName,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              const Spacer(),
              AppDrawerListTile(
                icon: Icons.help,
                title: 'Help',
                screen: HelpScreen.routeName,
              ),
              AppDrawerListTile(
                icon: Icons.settings,
                title: 'Settings',
                screen: SettingsScreen.routeName,
              ),
              const SizedBox(height: 10),
              AppDrawerFooter(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
