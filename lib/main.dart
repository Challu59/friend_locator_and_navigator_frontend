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

      //theme
      theme: ThemeData(
        useMaterial3: true,
        // primaryColor: Colors.deepOrange,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.orange.shade800,
            primary: Colors.orange.shade800,
          ),

        // theme for input fields
        inputDecorationTheme: InputDecorationThemeData(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide:  BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.orange.shade800, width: 2)
          )
        ),

          //theme for elevated buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade800,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
          )
      )
      ),

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

