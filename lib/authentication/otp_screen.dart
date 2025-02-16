import 'dart:async';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'twilio_service.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});
  @override
  OTPScreenState createState() => OTPScreenState();
}

class OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool otpSent = false;
  bool isLoading = false;
  String errorMessage = "";
  Timer? otpTimer;
  int otpTimeout = 60;

  late AnimationController _controller;
  late Animation<Color?> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat(reverse: true);

    _borderAnimation = _controller.drive(ColorTween(
      begin: Colors.blueAccent,
      end: Colors.purpleAccent,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    otpTimer?.cancel();
    super.dispose();
  }

  void startOTPTimer() {
    otpTimeout = 60;
    otpTimer?.cancel();
    otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (otpTimeout == 0) {
        timer.cancel();
        setState(() => otpSent = false);
        showSnackBar("OTP expired! Request a new one.", Colors.orange);
      } else {
        setState(() => otpTimeout--);
      }
    });
  }

  void sendOTP() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    String phoneNumber = "+91${phoneController.text.trim()}";
    if (phoneController.text.trim().isEmpty ||
        phoneController.text.length != 10) {
      setState(() {
        errorMessage = "Enter a valid 10-digit phone number";
        isLoading = false;
      });
      return;
    }

    bool success = await TwilioService.sendOTP(phoneNumber);
    if (success) {
      setState(() {
        otpSent = true;
        startOTPTimer();
      });
      showSnackBar("OTP sent successfully!", Colors.green);
    } else {
      setState(() => errorMessage = "Failed to send OTP. Try again!");
    }

    setState(() => isLoading = false);
  }

  void verifyOTP() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    String phoneNumber = "+91${phoneController.text.trim()}";
    String otp = otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      setState(() {
        errorMessage = "Enter a valid 6-digit OTP";
        isLoading = false;
      });
      return;
    }

    bool success = await TwilioService.verifyOTP(phoneNumber, otp, context);
    if (success) {
      otpTimer?.cancel();
      showSnackBar("OTP Verified Successfully!", Colors.green);
    } else {
      setState(() => errorMessage = "Invalid OTP. Try again!");
    }

    setState(() => isLoading = false);
  }

  void resetForm() {
    setState(() {
      phoneController.clear();
      otpController.clear();
      otpSent = false;
      errorMessage = "";
      otpTimer?.cancel();
    });
  }

  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Pure black background
      body: Center(
        child: AnimatedBuilder(
          animation: _borderAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _borderAnimation.value!, // Animated border color
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _borderAnimation.value!.withOpacity(0.6),
                    blurRadius: 10,
                    spreadRadius: 3,
                  )
                ],
              ),
              padding: EdgeInsets.all(3), // Border padding
              child: Card(
                color: Colors.black, // Inner card also black
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "OTP Authentication",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15),

                      /// Phone Number Input
                      TextField(
                        controller: phoneController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixText: "+91 ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon:
                              Icon(Icons.phone, color: Colors.blueAccent),
                        ),
                        keyboardType: TextInputType.phone,
                        enabled: !otpSent,
                      ),
                      SizedBox(height: 15),

                      /// OTP Input (Shown after OTP is sent)
                      if (otpSent)
                        Column(
                          children: [
                            TextField(
                              controller: otpController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Enter OTP",
                                labelStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.blueAccent),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "OTP Expires in: $otpTimeout sec",
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ],
                        ),
                      SizedBox(height: 20),

                      /// Error Message
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(errorMessage,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),

                      /// OTP Actions
                      isLoading
                          ? CircularProgressIndicator(color: Colors.blueAccent)
                          : ElevatedButton(
                              onPressed: otpSent ? verifyOTP : sendOTP,
                              child: Text(otpSent ? "Verify OTP" : "Send OTP"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 25),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                      SizedBox(height: 10),

                      /// Reset Button
                      // OutlinedButton(
                      //   onPressed: resetForm,
                      //   child: Text("Reset"),
                      //   style: OutlinedButton.styleFrom(
                      //     foregroundColor: Colors.blueAccent,
                      //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      //     textStyle: TextStyle(fontSize: 14),
                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      //     side: BorderSide(color: Colors.blueAccent),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
