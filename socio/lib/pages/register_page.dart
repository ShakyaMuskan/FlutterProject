import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socio/components/my_button.dart';
import 'package:socio/components/my_textfield.dart';
import 'package:socio/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  void registerUser() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Make sure passwords match
    if (passwordController.text != confirmPwController.text) {
      // Pop loading circle
      Navigator.pop(context);

      // Show error message to user
      displayMessagetoUSer("Passwords don't match", context);

      return;
    }
    //if passwords do not match
    else {
      try {
        // Create the user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // create a user document  and add to firestore
        createUserDocument(userCredential);

        // Pop loading circle
        if (context.mounted) Navigator.pop(context);

        // Additional actions can be taken here with userCredential if needed
      } on FirebaseAuthException catch (e) {
        // Pop loading circle
        Navigator.pop(context);

        // Display error message
        displayMessagetoUSer(e.message ?? "An error occurred", context);
      }
    }
    // Try creating the user
  }

  //create a user document and  collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),
              // App name
              const Text("S O C I O", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              // Username text field
              MyTextField(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 10),
              // Email text field
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),
              // Password text field
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              // Confirm password text field
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmPwController,
              ),
              const SizedBox(height: 25),
              // Sign up button
              MyButton(text: "Sign Up", onTap: registerUser),
              const SizedBox(height: 20),
              // Already have an account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login Here.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
