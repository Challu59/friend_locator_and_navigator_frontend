import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import '../core/storage/token_storage.dart';
import '../features/home/screens/main_shell_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async{
    final bool loggedIn = await TokenStorage.isLoggedIn();
    if(loggedIn){
      return const MainShellScreen();
    }
    else{
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.orange.shade900;
    final secondaryColor = Colors.amber.shade700;

    return  MaterialApp(
      title: 'NavChat',
      debugShowCheckedModeBanner: false,

      //theme
      theme: ThemeData(
        useMaterial3: true,
        // primaryColor: Colors.deepOrange,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor,
            primary: primaryColor,
            secondary: secondaryColor,
            surface: Colors.grey.shade50
          ),
        scaffoldBackgroundColor: Colors.grey.shade50,

        // theme for input fields
        inputDecorationTheme: InputDecorationThemeData(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIconColor: Colors.grey.shade500,
          suffixIconColor: Colors.grey.shade500,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide:  BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1)
            ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primaryColor, width: 2)
          )
        ),

          //theme for elevated buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          )
      ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)
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



