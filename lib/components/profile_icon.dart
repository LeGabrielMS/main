import 'package:flutter/material.dart';
import 'package:main/screens/profile_screen.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: CircleAvatar(
        radius: 20,
        backgroundImage: const AssetImage('assets/images/profile.jpg'),
      ),
    );
  }
}
