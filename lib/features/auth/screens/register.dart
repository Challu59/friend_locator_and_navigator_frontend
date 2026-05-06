import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = new AuthService();

  bool isLoading = false;

  void register() async{
    setState(() {
      isLoading = true;
    });

    final result = await authService.register(
        emailController.text,
        usernameController.text,
        passwordController.text
    );
    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding
        (padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Enter your email"
              ),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Enter your username"
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Enter your password"
              ),
            ),
            SizedBox(height: 20,),

            isLoading? CircularProgressIndicator():
            ElevatedButton(
                onPressed: register,
                child: Text("Register"))
          ],
        ),
      ),
    );
  }


}

