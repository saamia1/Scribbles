import "package:flutter/material.dart";
import "package:messaging_app/services/auth/auth_service.dart";
import "package:messaging_app/components/my_button.dart";
import "package:messaging_app/components/my_textfield.dart";

class RegisterPage extends StatelessWidget{
    //email and pwd controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  // Tap to go to Login page
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,});

  void register(BuildContext context) async {
    final authService = AuthService();

    // if passwords match -> create user 
    if(_pwdController.text == _confirmPwdController.text){
      try{
        await authService.signUpWithEmailAndPassword(_emailController.text, _pwdController.text);
      } catch(e){
        showDialog(
          // ignore: use_build_context_synchronously
          context: context, 
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else{
      showDialog(
          // ignore: use_build_context_synchronously
          context: context, 
          builder: (context) => const AlertDialog(
            title: Text("Passwords dont match!")),
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
              "Let's create an account for you!",
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

            const SizedBox(height: 10),

            MyTextField(
              hintText: "Confirm Password", 
              obscureText: true,
              controller: _confirmPwdController,),  

            const SizedBox(height: 25),
            // login button
            MyButton(
              text:"Register",
              onTap: () => register(context),
              ), 
            
            // register now
            const SizedBox(height: 25), 

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: 
                  TextStyle(color: Theme.of(context).colorScheme.primary),),
                GestureDetector(
                  onTap: onTap,
                  child: Text (
                    "Login Now!",
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