import 'package:flutter/material.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
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

    final success = await authService.register(
        emailController.text,
        usernameController.text,
        passwordController.text
    );
    setState(() {
      isLoading = false;
    }
    );

    if(success){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
             Text("Registration successful, please log in.",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.green,

        )
      );
      Navigator.pop(context);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text("Registration failed!!!",
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
        child:SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60,),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold
                  ),
                ),
                const Text(
                  "Join your friends now",
                  style: TextStyle(
                    fontSize: 16, color: Colors.grey
                  ),
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
                SizedBox(height: 10,),

                Text("Username",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8,),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      hintText: "YourName123",
                    prefixIcon: Icon(Icons.alternate_email)
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

                isLoading? Center(child: CircularProgressIndicator(),):
                ElevatedButton(
                    onPressed: register,
                    child: Text("Register", style: TextStyle(fontSize: 18),)),

                SizedBox(height: 5,),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Center(child: const Text("Already have an account? Login"),),
                ),
              ],
        )


        ),
      ),
    );
  }


}

