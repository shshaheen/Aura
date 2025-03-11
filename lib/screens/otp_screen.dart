import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aura/screens/profile_screen.dart';
import 'package:aura/screens/homepage.dart';

class OTPScreen extends StatefulWidget {
 
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  OTPScreenState createState() => OTPScreenState();
}

class OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String errorMessage = "";

  void verifyOTP() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    String otp = otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      setState(() {
        errorMessage = "Enter a valid 6-digit OTP";
        isLoading = false;
      });
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Check if user has completed profile (you can modify this logic)
        bool hasCompletedProfile =
            false; // Change this logic as per your database
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                hasCompletedProfile ? Homepage() : CompleteProfileScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() => errorMessage = "Invalid OTP");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
          child: Card(
            color: colorScheme.primary,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "OTP Authentication",
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: otpController,
                    style: TextStyle(color: colorScheme.onPrimary),
                    cursorColor: colorScheme.onPrimary,
                    decoration: InputDecoration(
                      labelText: "Enter Code:",
                      labelStyle: TextStyle(color: colorScheme.onPrimary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: colorScheme.onPrimaryContainer),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: colorScheme.onPrimary, width: 2),
                      ),
                      prefixIcon:
                          Icon(Icons.lock, color: colorScheme.onPrimary),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  isLoading
                      ? CircularProgressIndicator(color: Colors.blueAccent)
                      : ElevatedButton(
                          onPressed: verifyOTP,
                          child: Text("Verify"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.onSecondary,
                            foregroundColor: colorScheme.onSecondaryContainer,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
