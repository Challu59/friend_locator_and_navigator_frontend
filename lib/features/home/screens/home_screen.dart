import 'package:flutter/material.dart';
import '../../auth/models/user_models.dart';

import '../../auth/services/auth_service.dart';
import '../../chat/services/chat_service.dart';

import'../../../core/storage/session_storage.dart';
import '../../../core/storage/token_storage.dart';

import 'package:frontend/features/auth/screens/login_screen.dart';
import '../../chat/screens/chat_screen.dart';
import '../../friends/screens/friends_screen.dart';
import '../../friends/screens/requests_screen.dart';


class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  Future<void> logout(BuildContext context) async{
    await TokenStorage.clearTokens();
    await SessionStorage.clearUser();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
            (route) => false
    );
  }

  final AuthService authService = AuthService();

  String _getInitials(String username){
    if (username.isEmpty) return "?";
    return username[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Messages",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          letterSpacing: -0.5
          // color: Colors.orange.shade800
        ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const RequestsScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.notifications,
                ),
              ),


              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const FriendsScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.people,
                ),
              ),

              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle
                ),
                child: IconButton(
                  onPressed: () => logout(context),
                  icon: Icon(Icons.logout),
                  tooltip: 'LogOut',
                ),
              )
            ],
          )


        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future:  authService.fetchUsers(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasError) {
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 12),
                  Text(
                    "Something went wrong",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                  ),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
            );
          }

            final users = snapshot.data?? [];

            if(users.isEmpty){
              return const Center(
                child: Text("No users found"),
              );
            }

            return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: users.length,
                separatorBuilder: (context, index) =>
                Divider(color: Colors.grey.shade300, height: 1,),
                itemBuilder: (context, index){
                  final user = users[index];

                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        // hoverColor: Colors.grey.shade800,
                        // tileColor: Colors.orange.shade50,
                        leading:  CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.orange,
                          child: Text(_getInitials(user.username),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          ),
                        ),
                        title: Text(user.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        ),
                        subtitle: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(user.email,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                        ),

                        trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        onTap: () async{
                          final chatService = ChatService();
                          try{

                            final room = await chatService.createOrGetRoom(user.id);
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  roomId: room.id, otherUser: user,
                                ),
                              ),
                            );
                          }
                          catch(e){
                            debugPrint("Error navigating to chat screen: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                            content: const Text("Could not open chat."),
                            backgroundColor: Colors.red.shade700,
                            behavior: SnackBarBehavior.floating,
                            ),
                            );
                          }
                        },
                      ),
                  );

                }
            );
          }
    )
    );
  }

}

