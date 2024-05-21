import "package:flutter/material.dart";
import "package:messaging_app/components/my_drawer.dart";

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scribbles"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0
        ),
      drawer: const MyDrawer(),
      body: const Center(
        child: Text("Welcome to Scribbles!", 
        style: TextStyle(fontSize: 30),),
        
      )
    );
  }
}