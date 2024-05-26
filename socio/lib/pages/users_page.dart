import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socio/components/my_back_buttons.dart';
import 'package:socio/components/my_list_tile.dart';
import 'package:socio/helper/helper_function.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          //any errors
          if (snapshot.hasError) {
            displayMessagetoUSer("Something went wrong", context);
          }
          //show loading circle
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Text("No data");
          }

          //get all users
          final users = snapshot.data!.docs;

          return Column(
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
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    //get individual users
                    final user = users[index];

                    String username = user['username'];
                    String email = user['email'];

                    return MyListTile(title: username, subTitle: email);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
