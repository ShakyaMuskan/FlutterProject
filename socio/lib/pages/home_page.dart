import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socio/components/my_drawer.dart';
import 'package:socio/components/my_list_tile.dart';
import 'package:socio/components/my_post_button.dart';
import 'package:socio/components/my_textfield.dart';
import 'package:socio/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController newPostController = TextEditingController();

  //post message
  void postMessage() {
    //only post message if there is something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    //clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("S O C I O"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          //Textfield box for user to type
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                //text field
                Expanded(
                  child: MyTextField(
                      hintText: "Say Something..",
                      obscureText: false,
                      controller: newPostController),
                ),

                //post button
                MyPostButton(onTap: postMessage)
              ],
            ),
          ),
          const SizedBox(height: 20,),
          // posts
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              //get all posts
              final posts = snapshot.data!.docs;

              //no data
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No posts.. Post Something"),
                  ),
                );
              }
              //return as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    //get each individual post
                    final post = posts[index];

                    //get data from each post
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];

                    //return as a list tile
                    return MyListTile(title: message, subTitle: userEmail);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
