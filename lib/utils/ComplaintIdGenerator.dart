import 'package:shared_preferences/shared_preferences.dart';

class ComplaintIdGenerator {
  static const String _key = 'last_complaint_id';

  static Future<String> getNextComplaintId() async {
    final prefs = await SharedPreferences.getInstance();
    int lastId = prefs.getInt(_key) ?? 0;
    lastId++;
    await prefs.setInt(_key, lastId);
    return 'CD${lastId.toString().padLeft(5, '0')}';
  }
}
