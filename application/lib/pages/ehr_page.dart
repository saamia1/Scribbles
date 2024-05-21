import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/components/user_title.dart';
import 'package:messaging_app/pages/ehr_view.dart';
import 'package:messaging_app/services/ehr/ehr_service.dart';

class EHRPage extends StatelessWidget {
  EHRPage({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(
        title: const Text('Health Records'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0  
      ),


      body: StreamBuilder<QuerySnapshot>(

        stream: _firestoreService.streamData(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'), 
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), 
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              
              Map<String, dynamic> data = document.data() as Map<String, dynamic>? ?? {};

              List<String> fullName = [data["lastName"], data["firstName"]];
              String displayName = fullName.join(", ");

              return UserTile(
                  text: displayName,
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  EHRView(patientID: data["patientID"],))
                    );
                  }
                );
            }).toList(),
          );

        },
      ),
    );
  }
}
