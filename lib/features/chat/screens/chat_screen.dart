import 'package:flutter/material.dart';
import '../../auth/models/user_models.dart';

class ChatScreen extends StatelessWidget{
 final int roomId;
 final UserModel otherUser;

 const ChatScreen({
 super.key, required this.roomId, required this.otherUser
 });

 @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text(otherUser.username),
  ),
    body: Center(
    child: Text("Chat room : $roomId"),
    ),
    );
  }

}