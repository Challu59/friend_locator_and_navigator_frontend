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
  bool obscurePassword = true;

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
      _showSnackBar("Registration successful, please log in.", Colors.green);
      Navigator.pop(context);
    }

    else{
      _showSnackBar("Registration failed. Please try again.", Colors.red);
    }
    
  }

  void _showSnackBar(String message, Color bgColor){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: ()=> Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      extendBodyBehindAppBar: true,
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
                  obscureText: obscurePassword,
                  decoration:  InputDecoration(
                      hintText: "********",
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                        onPressed: ()=> setState(() {
                          obscurePassword = !obscurePassword;
                        }),
                        icon: Icon(obscurePassword? Icons.visibility_off_outlined: Icons.visibility_outlined),
                    )
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

