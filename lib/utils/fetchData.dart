import 'package:cloud_firestore/cloud_firestore.dart';

Future<double> fetchCurrentMonthAverageRating() async {
  try {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Ratings')
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
        .where('createdAt',
            isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
        .get();
    if (snapshot.docs.isEmpty) {
      return 0.0;
    }

    // Extract ratings and calculate average
    final ratings =
        snapshot.docs.map((doc) => doc['Rating'] as double).toList();

    final total = ratings.fold<double>(0, (sum, item) => sum + item);
    final average = total / ratings.length;
    return average;
  } catch (e) {
    print("Error fetching ratings: $e");
    return 0.0;
  }
}

Future<List<String>> fetchDepartmentNames() async {
  try {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Departments').get();

    List<String> departmentNames =
        snapshot.docs.map((doc) => doc['DepartmentName'] as String).toList();

    return departmentNames;
  } catch (e) {
    print('Error fetching departments: $e');
    return [];
  }
}
