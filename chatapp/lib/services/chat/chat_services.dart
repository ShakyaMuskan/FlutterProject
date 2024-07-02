import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  //get instance of firestore and auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //get user services

/*
[
{
"email":test@gmail.com,
"id":..
},   --> map of users
] --> list of maps
*/
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual users
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  //send messages
  Future<void> sendMessage(String recieverId, String message) async {
    //get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new  message
    Message newMessgae = Message(
        senderID: currentUserId,
        senderEmail: currentUserEmail,
        recieverId: recieverId,
        message: message,
        timestamp: timestamp);

    //construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, recieverId];
    ids.sort(); //sort the ids (this ensures the chatroomID is the same for any 2 people)
    String chatroomID = ids.join('_');
    //add new message to database

    await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .add(newMessgae.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId, otherUserID) {
    //construct a chatroom ID for the two users
    List<String> ids = [userId, otherUserID];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
