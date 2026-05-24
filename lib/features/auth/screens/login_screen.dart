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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60,),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    // color: Colors.orange.shade800.withAlpha(30)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Icon(Icons.chat_bubble_outline_rounded,
                    size: 40, color: Colors.orange.shade800,
                  ),
                    SizedBox(width: 10,),
                    Text("NavChat",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                ],)
              ),

              SizedBox(height: 30,),

              Text("Welcome back",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text("Log in to chat with your friends",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              SizedBox(height: 30,),

              Text("Email",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8,),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "navchat@gmail.com",
                  prefixIcon: Icon(Icons.email_outlined)
                ),
              ),

              SizedBox(height: 20,),

              Text("Password",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8,),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "********",
                  prefixIcon: Icon(Icons.lock_outline)
                ),
              ),
              SizedBox(height: 20,),

              isLoading? const Center(child: CircularProgressIndicator(),):
              ElevatedButton(
                  onPressed: login,
                  child: const Text("Login",
                  style: TextStyle(fontSize: 18),
                  ),
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
                child: Center(child: Text("Don't have an account? Register"),),
              ),

            ],
          ),
        )

      ),
    );
  }
}