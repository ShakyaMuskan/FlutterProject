import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // Text controllers
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  // tap to go to register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add some space at the top
                SizedBox(height: 50),

                // Logo
                Icon(
                  Icons.message,
                  size: 65,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(height: 35),

                // Welcome back message
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                // Email textfield
                MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailcontroller,
                ),
                const SizedBox(height: 15),

                // Password textfield
                MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: _passwordcontroller,
                ),
                const SizedBox(height: 5),

                // Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Login button
                MyButton(
                  text: "LOGIN",
                  onTap: () => login(context),
                ),
                const SizedBox(height: 8),

                // Don't have an account? Register Now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(" Register now",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                // Add some space at the bottom
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    final authService = AuthService();

    // Try login
    try {
      await authService.signInWithEmailPassword(
          _emailcontroller.text, _passwordcontroller.text);
      // Navigate to the next screen or show success message
    } catch (e) {
      // Catch errors and show a dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
