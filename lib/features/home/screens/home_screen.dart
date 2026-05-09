import 'package:flutter/material.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import '../../../core/storage/token_storage.dart';

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
      body: Center(
        child: Text("Welcome"),
      ),
    );
  }

}