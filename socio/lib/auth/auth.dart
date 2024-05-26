import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socio/auth/login_or_register.dart';
import 'package:socio/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //user logged in
        if (snapshot.hasData) {
          return  HomePage();
        }

        //user is NOT logged in
        else {
          return const LoginOrRegister();
        }
      },
    ));
  }
}
