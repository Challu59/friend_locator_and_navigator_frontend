import 'package:flutter/material.dart';
import 'package:frontend/features/chat/services/chat_service.dart';
import '../../auth/models/user_models.dart';
import '../../chat/models/message_model.dart';
import '../../../core/storage/session_storage.dart';

class ChatScreen extends StatefulWidget{
 final int roomId;
 final UserModel otherUser;

 const ChatScreen({
   super.key,
   required this.roomId,
   required this.otherUser
 });

 @override
 State<ChatScreen> createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen>{
    final ChatService chatService = ChatService();
    final TextEditingController messageController = TextEditingController();
    final ScrollController scrollController = ScrollController();

    List<MessageModel> messages = [];

    bool isLoading = true;
    bool isSending = false;
    int? currentUserId;

    @override
    void initState(){
      super.initState();
      initializeChat();
    }

    Future<void> initializeChat() async{
      currentUserId = await SessionStorage.getUserId();
      await loadMessages();
    }

    Future<void> loadMessages() async{
      try{
        final fetchedMessages = await chatService.fetchMessages(widget.roomId);
        setState(() {
          messages = fetchedMessages;
          isLoading = false;
        });



      }catch(e){
        setState(() {
          isLoading = false;
        });
      }
    }

    Future<void> sendMessage() async{
      final content = messageController.text.trim();
      if(content.isEmpty || isSending){
        return;
      }

      setState(() {
        isSending = true;
      });

      try{
        final message = await chatService.sendMessage(widget.roomId, content);
            setState(() {
              messages.add(message);
              messageController.clear();
            });


      }finally{
        setState(() {
          isSending = false;
        });
      }

    }



}







