import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getDocumentById(String id) async {
    var document = _firestore.collection('EHRs').doc(id);
    return await document.get();
  }

  Future<List<QueryDocumentSnapshot>> getDocuments() async {
    var collection = _firestore.collection('EHRs');
    var querySnapshot = await collection.get();
    return querySnapshot.docs;
  }

  Stream<QuerySnapshot> streamData() {
    return _firestore.collection('EHRs').snapshots();
  }
}
