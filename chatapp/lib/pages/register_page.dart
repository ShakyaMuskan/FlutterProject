import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confPwController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) async {
    final _auth = AuthService();

    //if password matchs -> create user
    if (_passwordcontroller.text == _confPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
            _emailcontroller.text.trim(), _passwordcontroller.text.trim());
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }
    //if passwords don't match -> show error
    else {
      showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(title: Text("Passwords don't match")));
    }
  }

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
                const SizedBox(height: 15),

                // Confirm Password textfield
                MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: _confPwController,
                ),
                const SizedBox(height: 25),

                // Register button
                MyButton(
                  text: "REGISTER",
                  onTap: () => register(context),
                ),
                const SizedBox(height: 8),

                // Already have an account? Login Here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(" Login Here",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                // Add some space at the bottom
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
