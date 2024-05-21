import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/components/user_title.dart';
import 'package:messaging_app/pages/ai_page.dart';
import 'package:messaging_app/services/ehr/ehr_service.dart';

class EHRView extends StatelessWidget {
  final String patientID;

  EHRView({
    super.key,
    required this.patientID,
  });

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Record"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0
      ),


      body: FutureBuilder<DocumentSnapshot>(
        future: _firestoreService.getDocumentById(patientID),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(child: Text("No data found"));
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          print("Fetched data: $data");
          return _buildEHRItem(data, context);  
        },
      ),
    );
  }

  Widget _buildEHRItem(Map<String, dynamic> data, BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
        
            Container(
              color: Theme.of(context).colorScheme.primary, 
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    UserTile(
                      text: "Summarize",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AIPage(category: "Summarize", ehrData: data)),
                        );
                      },
                    ),
                    UserTile(
                      text: "AI Analysis",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AIPage(category: "AI Analysis", ehrData: data)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "${data["firstName"]} ${data["lastName"]}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                )
            ),
            const SizedBox(height: 20),
            Text("Personal Information"),
            const SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
              child: Table(
                children: [
                  TableRow(children: [
                    Text("First Name"),
                    Text(data["firstName"])
                  ]),
              
                  TableRow(children: [
                    Text("Last Name"),
                    Text(data["lastName"])
                  ]),
              
                  TableRow(children: [
                    Text("Preferred Name"),
                    Text(data["preferredName"])
                  ]),
              
                  TableRow(children: [
                    Text("Gender"),
                    Text(data["gender"])
                  ]),
              
                  TableRow(children: [
                    Text("Date of Birth"),
                    Text("${data["dateOfBirth"]["day"]}/${data["dateOfBirth"]["month"]}/${data["dateOfBirth"]["year"]}")
                  ]),
              
                  TableRow(children: [
                    Text("Blood Type"),
                    Text(data["bloodType"])
                  ]),
              
                  TableRow(children: [
                    Text("Last Updated"),
                    Text("${data["lastUpdated"]["day"]}/${data["lastUpdated"]["month"]}/${data["lastUpdated"]["year"]}")
                  ]),
              
                  TableRow(children: [
                    Text("Address"),
                    Text(data["address"])
                  ]),
              
                  TableRow(children: [
                    Text("City"),
                    Text(data["city"])
                  ]),
              
                  TableRow(children: [
                    Text("State"),
                    Text(data["state"])
                  ]),
              
                  TableRow(children: [
                    Text("Postal Code"),
                    Text(data["postalCode"])
                  ]),
                ]
              ),
            ),
            const SizedBox(height: 20),
            Text("Emergency Contact"),
            const SizedBox(height: 5), 
            Container(
              padding: EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
              child: Table(
                children: [
                  TableRow(children: [
                    Text("First Name"),
                    Text(data["emergencyContact"]["firstName"])
                  ]),
                      
                  TableRow(children: [
                    Text("Last Name"),
                    Text(data["emergencyContact"]["lastName"])
                  ]),
                      
                  TableRow(children: [
                    Text("Relationship"),
                    Text(data["emergencyContact"]["relationship"])
                  ]),
                      
                  TableRow(children: [
                    Text("Contact Number"),
                    Text(data["emergencyContact"]["contactNumber"])
                  ]),
                ]
              ),
            ),
            const SizedBox(height: 20), 
            Text("Insurance Information"),
            const SizedBox(height: 10), 
            Container(
              padding: EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
              child: Table(
                children: [
                  TableRow(children: [
                    Text("Insurance Carrier"),
                    Text(data["insurance"]["carrier"])
                  ]),
                      
                  TableRow(children: [
                    Text("Insurance Plan"),
                    Text(data["insurance"]["plan"])
                  ]),
                      
                  TableRow(children: [
                    Text("Contact Number"),
                    Text(data["insurance"]["contactNumber"])
                  ]),
                      
                  TableRow(children: [
                    Text("Policy Number"),
                    Text(data["insurance"]["policyNumber"])
                  ]),
                ]
              ),
            ),
        
            
            const SizedBox(height: 20), 
        
            Text("Known Medical Conditions"),
            const SizedBox(height: 10), 
            Container(
              padding: EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
              child: Table(
                children: [
                  TableRow(children: [
                    Text(data["knownMedicalConditions"]),
                  ]),
                ]
              ),
            ),
        
            const SizedBox(height: 20), 
        
            Text("Allergies"),
            const SizedBox(height: 10), 
            Container(
              padding: EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
              child: Table(
                children: [
                  TableRow(children: [
                    Text(data["allergies"]),
                  ]),
                ]
              ),
            ),
        
          ],
        ),
      )
      
      
      );
  }
}
