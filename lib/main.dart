import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import '../core/storage/token_storage.dart';
import '../features/home/screens/home_screen.dart';
import '../features/auth/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async{
    final bool loggedIn = await TokenStorage.isLoggedIn();
    if(loggedIn){
      return const HomeScreen();
    }
    else{
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'NavChat',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(future:_getInitialScreen(),
          builder: (context, snapshot){
        if(!snapshot.hasData){
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        else {
          return snapshot.data!;
        }
          }

      ),
    );
  }
}

