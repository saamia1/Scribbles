import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:messaging_app/pages/chathome_page.dart";
import "package:messaging_app/pages/ehr_page.dart";
import "package:messaging_app/pages/login_page.dart";
import "package:messaging_app/pages/register_page.dart";
import "package:messaging_app/pages/welcome_page.dart";
import "package:messaging_app/services/auth/auth_service.dart";
import "package:messaging_app/pages/settings_page.dart";
import "package:messaging_app/pages/reminder_page.dart";
import 'package:messaging_app/pages/pager_page.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(){
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //logo 
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  )
                )
              ),

              //home list title
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
                  }
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("R E M I N D E R"),
                  leading: const Icon(Icons.notifications), // Changed the icon to notifications
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    User? user = AuthService().getCurrentUser();
                    if (user != null) {
                      // If user is not null, navigate to ReminderPage with userId
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReminderPage(userID: user.uid)));
                    } else {
                      // If no user is signed in, navigate to the LoginPage with the necessary onTap function
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(onTap: () {  },))); // Assuming RegisterPage handles registrations
                      })));
                    }
                  }
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("E H R"),
                  leading: const Icon(Icons.edit_document),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EHRPage()));
                  }
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("C H A T"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatHomePage()));
                  }
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('P A G I N G'),
                  leading: const Icon(Icons.notifications),
                  onTap: () {
                  Navigator.pop(context);  // This will close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PagerPage()),
                  );
                },
                ),
              ),

              //settings list title
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                  }
                ),
              ),
            ],
          ),
          
          //logout list title
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 20.0),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: logout
            ),
          )

      ],)
    );
  }
}