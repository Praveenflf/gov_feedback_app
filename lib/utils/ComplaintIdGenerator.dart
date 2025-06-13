import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getNextComplaintIdFromFirestore() async {
  try {
    // Query the Complaints collection, order by 'createdAt' descending, get only the latest
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Complaints')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return 'complaint-01'; // If no complaints yet, start from CD00001
    }

    // Extract the latest complaint ID
    String lastId = snapshot.docs.first['Document ID'] ?? 'complaint-00';

    // Extract numeric part
    int numericPart = int.tryParse(lastId.replaceAll('complaint-', '')) ?? 0;
    numericPart++;

    // Generate next ID
    return 'complaint-${numericPart.toString().padLeft(5, '0')}';
  } catch (e) {
    print("Error fetching last complaint ID: $e");
    return 'complaint-01'; // fallback
  }
}
