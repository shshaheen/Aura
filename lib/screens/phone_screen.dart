import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otp_screen.dart';
import 'package:aura/main.dart';

class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String errorMessage = "";

  void sendOTP() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    String phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      setState(() {
        errorMessage = "Enter a valid 10-digit phone number";
        isLoading = false;
      });
      return;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$phone",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        String userFriendlyMessage = "Verification Failed. Please try again.";

        if (e.code == 'quota-exceeded') {
          userFriendlyMessage = "Too many verification attempts. Try again later.";
        } else if (e.code == 'app-not-authorized') {
          userFriendlyMessage = "App is not authorized for authentication. Contact support.";
        } else if (e.code == 'missing-client-identifier') {
          userFriendlyMessage = "Billing is not enabled. Contact the developer.";
        } else {
          userFriendlyMessage = e.message ?? "An unexpected error occurred.";
        }

        setState(() {
          errorMessage = userFriendlyMessage;
          isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final colorScheme = isDarkMode ? kDarkColorScheme : kLightColorScheme;
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
        padding: const EdgeInsets.all(14.0),
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
                    "Phone Authentication",
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 15),
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
                        borderSide: BorderSide(color: colorScheme.onPrimaryContainer),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.onPrimary, width: 2),
                      ),
                      prefixIcon: Icon(Icons.phone, color: colorScheme.onPrimary),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20),

                  // Display the error message in a properly styled container
                  if (errorMessage.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade900),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  isLoading
                      ? CircularProgressIndicator(color: Colors.blueAccent)
                      : ElevatedButton(
                          onPressed: sendOTP,
                          child: Text("Send OTP"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.onSecondary,
                            foregroundColor: colorScheme.onSecondaryContainer,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
