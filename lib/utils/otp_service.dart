import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  static const String accountSid = 'ACa5777c0cb15c82a0c955f10457a4f578';
  static const String authToken = 'b3bfbbe815b9834b54704b226cc35626';
  static const String verifySid = 'VA2e63fd2d8e5627a1afbbdca92730c344';

  static String get _basicAuth =>
      'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}';

  static Future<bool> sendOtp(String phoneNumber) async {
    final url = Uri.https(
      'verify.twilio.com',
      '/v2/Services/$verifySid/Verifications',
    );

    final response = await http.post(
      url,
      headers: {
        'Authorization': _basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'To': phoneNumber,
        'Channel': 'sms',
      },
    );

    print('Send OTP Status: ${response.statusCode}');
    print(response.body);

    return response.statusCode == 201;
  }

  static Future<bool> verifyOtp(String phoneNumber, String code) async {
    final url = Uri.https(
      'verify.twilio.com',
      '/v2/Services/$verifySid/VerificationCheck',
    );

    final response = await http.post(
      url,
      headers: {
        'Authorization': _basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'To': phoneNumber,
        'Code': code,
      },
    );

    print('Verify OTP Status: ${response.statusCode}');
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 'approved';
    } else {
      return false;
    }
  }
}
