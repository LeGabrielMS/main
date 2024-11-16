import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/components/drawer.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:main/screens/notes_screen.dart';
import 'package:main/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const NotesScreen(),
    const ToDoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: theme.colorScheme.primary,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        drawer: MyDrawer(),
        body: _screens[_selectedIndex],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WaterDropNavBar(
              backgroundColor: theme.colorScheme.primary,
              waterDropColor: theme.colorScheme.inversePrimary,
              inactiveIconColor: theme.colorScheme.inversePrimary,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              bottomPadding: 8,
              barItems: [
                BarItem(
                  filledIcon: Icons.note_alt,
                  outlinedIcon: Icons.note_alt_outlined,
                ),
                BarItem(
                  filledIcon: Icons.assignment_turned_in,
                  outlinedIcon: Icons.assignment_turned_in_outlined,
                ),
              ],
              selectedIndex: _selectedIndex,
            ),
            Container(
              color: theme.colorScheme.primary,
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Notes',
                    style: TextStyle(
                      color: _selectedIndex == 0
                          ? theme.colorScheme.inversePrimary
                          : theme.colorScheme.inversePrimary,
                      fontWeight: _selectedIndex == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  Text(
                    'To-Do',
                    style: TextStyle(
                      color: _selectedIndex == 1
                          ? theme.colorScheme.inversePrimary
                          : theme.colorScheme.inversePrimary,
                      fontWeight: _selectedIndex == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
