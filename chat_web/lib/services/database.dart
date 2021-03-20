import 'package:chat_web/utils/firebaseConstans.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await db
        .collection('users')
        .where('name', isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String useremail) async {
    return await db
        .collection('users')
        .where('email', isEqualTo: useremail)
        .get();
  }

  uploadUserInfo(userMap) {
    db.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatroomId, chatRoomMap) {
    db.collection('chatroom').doc(chatroomId).set(chatRoomMap).catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatroomId, messageMap) {
    db
        .collection('chatroom')
        .doc(chatroomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatroomId) async {
    return db
        .collection('chatroom')
        .doc(chatroomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return db
        .collection("chatroom")
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
