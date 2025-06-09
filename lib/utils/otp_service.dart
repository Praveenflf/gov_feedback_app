import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  // Replace with your actual backend base URL
  static const String baseUrl = 'http://localhost:3000';

  /// Sends OTP to the given contact (email or phone)
  static Future<bool> sendOtp(String contact) async {
    final url = Uri.parse('$baseUrl/send-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': contact}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Send OTP failed [${response.statusCode}]: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception in sendOtp: $e");
      return false;
    }
  }

  /// Verifies the provided OTP against the given contact
  static Future<bool> verifyOtp(String contact, String otp) async {
    final url = Uri.parse('$baseUrl/verify-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': contact, 'code': otp}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Verify OTP failed [${response.statusCode}]: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception in verifyOtp: $e");
      return false;
    }
  }
}
