import 'package:flutter/material.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import '../../../core/storage/token_storage.dart';
import '../../auth/models/user_models.dart';
import '../../auth/services/auth_service.dart';
import '../../chat/services/chat_service.dart';
import '../../chat/screens/chat_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  Future<void> logout(BuildContext context) async{
    await TokenStorage.clearTokens();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
            (route) => false
    );
  }

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(
          onPressed: () => logout(context),
            icon: Icon(Icons.logout),
            tooltip: 'LogOut',
      ),
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
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
            final users = snapshot.data?? [];

            if(users.isEmpty){
              return const Center(
                child: Text("No users found"),
              );
            }

            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index){
                  final user = users[index];

                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(user.username),
                    subtitle: Text(user.email),
                    onTap: () async{
                      final chatService =  ChatService();
                      final room = await chatService.createOrGetRoom(user.id);
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                  roomId: room.id, otherUser: user
                              )
                          )
                      );
                  },
                  );
                }
            );
          }
    )
    );
  }

}