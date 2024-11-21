import 'package:flutter/material.dart';
import 'package:main/components/drawer_tile.dart';
import 'package:main/screens/settings_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Header
          DrawerHeader(
            child: Icon(Icons.note),
          ),

          // Settings tile
          DrawerTile(
            title: 'Settings',
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
