import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socio/components/my_back_buttons.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // Current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Handle data received state
          if (snapshot.hasData) {
            var userData = snapshot.data!.data();
            if (userData == null) {
              return const Center(child: Text('No Data Found'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 50.0,
                      left: 25,
                    ),
                    child: Row(
                      children: [
                        MyBackButtons(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.all(25),
                    child: const Icon(Icons.person, size: 64),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text('Username: ${userData['username']}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Email: ${userData['email']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600])),
                  // Add more fields as necessary
                ],
              ),
            );
          }

          // Handle the case where no data is found
          return const Center(child: Text('No Data Available'));
        },
      ),
    );
  }
}
