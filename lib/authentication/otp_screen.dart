import 'dart:async';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'twilio_service.dart';
import 'package:aura/main.dart';
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
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat(reverse: true);
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
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    final colorScheme = isDarkMode ? kDarkColorScheme : kLightColorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(// Pure black background
      body: Container(
        
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              colorScheme.primaryContainer.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Container(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(20),
              
            // ),
            padding: EdgeInsets.all(3), // Border padding
            child: Card(
              color: colorScheme.primary, // Inner card also black
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
                      style: textTheme.headlineSmall?.copyWith( 
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary),
                    ),
                    SizedBox(height: 15),
                  
                    /// Phone Number Input
                    TextField(
                      controller: phoneController,
                      style: TextStyle(color: colorScheme.onPrimary),
                      cursorColor: colorScheme.onPrimary, 
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(color: colorScheme.onPrimary),
                        prefixText: "+91 ",
                        prefixStyle: TextStyle(color: colorScheme.onPrimary), 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.onPrimaryContainer), // Default border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.onPrimary, width: 2, ), // Focused border
                        ),
                        prefixIcon: Icon(Icons.phone, color: colorScheme.onPrimary),
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
                              style: TextStyle(color: colorScheme.onPrimary),
                              cursorColor: colorScheme.onPrimary,
                              decoration: InputDecoration(
                                labelText: "Enter OTP",
                                labelStyle: TextStyle(color: colorScheme.onPrimary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.onPrimaryContainer),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.onPrimaryContainer, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.onPrimary, width: 1.5),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey, width: 1),
                                ),
                                prefixIcon: Icon(Icons.lock, color: colorScheme.onPrimary),
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
                              backgroundColor: colorScheme.onSecondary,
                              foregroundColor: colorScheme.onSecondaryContainer,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 25),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                    SizedBox(height: 10),
                  
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}