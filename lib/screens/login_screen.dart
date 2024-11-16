import 'package:flutter/material.dart';
import 'package:main/widgets/nav_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Simulated authentication logic
  bool _authenticate(String username, String password) {
    const correctUsername = 'Gabriel';
    const correctPassword = '123';
    return username == correctUsername && password == correctPassword;
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // Display error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Handle login
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (_authenticate(username, password)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: username),
        ),
      );
    } else {
      _showErrorDialog('Incorrect username or password.');
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 20),
              // Username Form Field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface, // Dynamic fill color
                ),
                style: TextStyle(color: colorScheme.inversePrimary),
              ),
              const SizedBox(height: 16),
              // Password Form Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: colorScheme.inversePrimary,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                style: TextStyle(color: colorScheme.inversePrimary),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: colorScheme.inversePrimary,
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: colorScheme.surface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
