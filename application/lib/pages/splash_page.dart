import "package:flutter/material.dart";
import "package:messaging_app/services/auth/auth_gate.dart";


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => const AuthGate()));
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Image.asset('assets/scribbles.png'), // Path to your logo asset
        ),
      ),
    );
  }
}
