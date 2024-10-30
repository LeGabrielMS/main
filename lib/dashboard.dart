import 'package:flutter/material.dart';
import 'package:main/login.dart';

class DashboardPage extends StatelessWidget {
  final String username;

  const DashboardPage({super.key, required this.username});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // AppBar is commented out, if you want to use it, uncomment below
      /* appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ), */
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, $username!',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700]),
            ),
            const SizedBox(height: 10),
            Text(
              'Welcome to your dashboard\nThere\'s nothing to do here...',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey[400]),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.blueGrey,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
