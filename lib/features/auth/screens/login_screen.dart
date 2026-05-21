import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/storage/session_storage.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  void login() async{
    setState(() {
      isLoading = true;
    });

    final result = await authService.login(
      emailController.text,
      passwordController.text
    );
     setState(() {
       isLoading = false;
     });

     //login successful
     if(result != null){
       await TokenStorage.saveTokens(
           accessToken: result['access'],
           refreshToken: result['refresh']
       );

       final user = result['user'];

       await SessionStorage.saveUser(
           userId: user['id'],
           username: user['username'],
           email: user['email']
       );
       
       Navigator.pushReplacement(
         context, 
        MaterialPageRoute(builder: (_) => const HomeScreen(),)
       );

       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content:
         Text("Login successful",
           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
           backgroundColor: Colors.green,
         )
       );
     }

     else{
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content:
         Text("Invalid credentials.",
           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
           backgroundColor: Colors.red,
         )
       );
     }


  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Enter your email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Enter your password"),
            ),
            SizedBox(height: 10,),

            isLoading? const CircularProgressIndicator():
            ElevatedButton(
                onPressed: login,
                child: const Text("Login")
            ),
            
            SizedBox(height: 5,),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),

          ],
        ),
      ),
    );
  }
}