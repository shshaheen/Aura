import 'package:flutter/material.dart';
import 'twilio_service.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool otpSent = false;

  void sendOTP() async {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isNotEmpty) {
      bool success = await TwilioService.sendOTP(phoneNumber);
      if (success) {
        setState(() {
          otpSent = true;
        });
      }
    }
  }

  void verifyOTP() async {
    String phoneNumber = phoneController.text.trim();
    String otp = otpController.text.trim();
    if (otp.isNotEmpty) {
      bool success = await TwilioService.verifyOTP(phoneNumber, otp);
      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("OTP Verified Successfully!")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid OTP!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Authentication")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            if (otpSent)
              TextField(
                controller: otpController,
                decoration: InputDecoration(labelText: "Enter OTP"),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: otpSent ? verifyOTP : sendOTP,
              child: Text(otpSent ? "Verify OTP" : "Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
