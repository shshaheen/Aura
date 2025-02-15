import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TwilioService {
  static String accountSID = dotenv.env['ACCOUNT_SID'] ?? ''; // Twilio Account SID
  static String authToken = dotenv.env['AUTH_TOKEN'] ?? ''; // Twilio Auth Token
  // static const String twilioNumber = ""; // Twilio Phone Number
  static String twilioVerifySID = dotenv.env['TWILIO_VERIFY_SID'] ?? ''; // Twilio Verify Service SID

  static Future<bool> sendOTP(String phoneNumber) async {
    final Uri uri = Uri.parse(
        "https://verify.twilio.com/v2/Services/$twilioVerifySID/Verifications");

    final response = await http.post(
      uri,
      headers: {
        "Authorization":
            "Basic ${base64Encode(utf8.encode('$accountSID:$authToken'))}",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "To": phoneNumber,
        "Channel": "sms", // Can also use "call" for voice OTP
      },
    );

    if (response.statusCode == 201) {
      print("OTP Sent Successfully!");
      return true;
    } else {
      print("Failed to send OTP: ${response.body}");
      return false;
    }
  }

  static Future<bool> verifyOTP(String phoneNumber, String otp) async {
    final Uri uri = Uri.parse(
        "https://verify.twilio.com/v2/Services/$twilioVerifySID/VerificationCheck");

    final response = await http.post(
      uri,
      headers: {
        "Authorization":
            "Basic ${base64Encode(utf8.encode('$accountSID:$authToken'))}",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "To": phoneNumber,
        "Code": otp,
      },
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData["status"] == "approved") {
      print("OTP Verified Successfully!");
      return true;
    } else {
      print("Failed to verify OTP: ${response.body}");
      return false;
    }
  }
}
