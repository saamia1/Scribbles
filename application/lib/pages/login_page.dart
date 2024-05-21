import 'package:flutter/material.dart';
import 'package:messaging_app/services/auth/auth_service.dart';
import 'package:messaging_app/components/my_button.dart';
import 'package:messaging_app/components/my_textfield.dart';


class LoginPage extends StatelessWidget {

  //email and pwd controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  // Tap to go to resgister page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap,});

  void login (BuildContext context) async {
    final authService = AuthService();
    try{
      await authService.signInWithEmailAndPassword(_emailController.text, _pwdController.text);
    }
    catch(e){
      showDialog(
        // ignore: use_build_context_synchronously
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ), // Icon
            const SizedBox(height: 50),
            // welcome back message
            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ), 
            ), 
            const SizedBox(height: 25),
            // email textfield
            MyTextField(
              hintText: "Email", 
              obscureText: false,
              controller: _emailController,),

            const SizedBox(height: 10),

            MyTextField(
              hintText: "Password", 
              obscureText: true,
              controller: _pwdController,),  

            const SizedBox(height: 25),
            // login button
            MyButton(
              text:"Login",
              onTap: () => login(context),
              ), 
            // register now
            const SizedBox(height: 25), 

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a Member? ",
                  style: 
                  TextStyle(color: Theme.of(context).colorScheme.primary),),
                GestureDetector(
                  onTap: onTap,
                  child: Text (
                    "Register Now!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ),
                ),
              ],
            )
          ], 

        ), 
      ), 
    ); 
  }
}