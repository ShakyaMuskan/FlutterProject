import 'package:flutter/material.dart';
import 'package:socio/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socio/auth/login_or_register.dart';
import 'package:socio/firebase_options.dart';
import 'package:socio/pages/home_page.dart';
import 'package:socio/pages/profile_page.dart';
import 'package:socio/pages/users_page.dart';
import 'package:socio/theme/dark_mode.dart';
import 'package:socio/theme/light_mode.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/login_register_page':(context) => const LoginOrRegister(),
        '/home_page':(context) =>  HomePage(),
        '/profile_page':(context) =>  ProfilePage(),
        '/users_page':(context)=> const UsersPage()
      },
    );
  }
}

