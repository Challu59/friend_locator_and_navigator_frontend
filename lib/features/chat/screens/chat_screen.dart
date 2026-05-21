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

        _scrollToBottom();

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
        _scrollToBottom();

      }finally{
        setState(() {
          isSending = false;
        });
      }
    }

    void _scrollToBottom(){
      WidgetsBinding.instance.addPostFrameCallback((_){
        if(!scrollController.hasClients){
          return;
        }

        scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
      );
    }

    bool isCurrentUser(MessageModel message){
      return message.sender == currentUserId;
    }

    Widget buildMessageBubble(MessageModel message){
      final isMine = isCurrentUser(message);

      return Align(
        alignment: isMine? Alignment.centerRight: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: isMine?Colors.orange.shade100:Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(message.content),
        ),
      );
    }

    @override

  void dispose(){
      messageController.dispose();
      scrollController.dispose();
      super.dispose();
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUser.username),
      ),
      body: Column(
        children: [
          Expanded(child: isLoading?
              const Center(
                child: CircularProgressIndicator(),
              )
              :
              RefreshIndicator(
                  onRefresh: loadMessages,
                  child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: messages.length,
                      itemBuilder: (context, index){
                        return buildMessageBubble(
                            messages[index],
                        );
                      },
                  ),
              ),
          ),
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                        child:
                        TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: "Type message....",
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => sendMessage(),
                        ),
                    ),
                    const SizedBox(width: 8,),
                    isSending? const Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),

                    )
                        :
                        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
                  ],
                ),
              ),
          )
        ],
      ),
    );
  }

}







