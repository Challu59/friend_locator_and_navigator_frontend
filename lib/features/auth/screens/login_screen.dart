import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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

     if(result!=null){
       print("Access token: ${result['access']}");
     }
     else{
       print("Login failed");
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
          ],
        ),
      ),
    );
  }
}