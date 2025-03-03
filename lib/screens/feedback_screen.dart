import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: FeedbackScreen(),
  ));
}

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  Widget iconstate = Icon(
    Icons.sentiment_satisfied,
    size: 50,
    color: Colors.pink,
  );
  double _sliderValue = 0;
  TextEditingController _feedbackController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  void submitFeedback() {
    FirebaseFirestore.instance.collection("feedback").add({
      "iconState": _sliderValue == 0 ? "Happy" : _sliderValue == 1 ? "Unhappy" : "Confused",
      "feedback": _feedbackController.text,
      "email": _emailController.text,
      "timestamp": FieldValue.serverTimestamp(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Feedback submitted successfully!")),
      );
      _feedbackController.clear();
      _emailController.clear();
      setState(() {
        _sliderValue = 0; // Reset slider
        iconstate = Icon(Icons.sentiment_satisfied, size: 50, color: Colors.pink);
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Colors.purple[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "How do you feel using our app?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    iconstate,
                    Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 2,
                      divisions: 2,
                      activeColor: Colors.pink,
                      onChanged: (value) {
                        setState(() {
                          if (value == 0) {
                            iconstate = Icon(
                              Icons.sentiment_satisfied,
                              size: 50,
                              color: Colors.pink,
                            );
                          } else if (value == 1) {
                            iconstate = Icon(
                              Icons.sentiment_dissatisfied,
                              size: 50,
                              color: Colors.pink,
                            );
                          } else {
                            iconstate = Icon(
                              Icons.sentiment_neutral,
                              size: 50,
                              color: Colors.pink,
                            );
                          }
                          _sliderValue = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Happy", style: TextStyle(color: Colors.pink)),
                        Text("Unhappy"),
                        Text("Confused"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Tell us more",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text("Email ID", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {
                  if (_emailController.text.isNotEmpty && _feedbackController.text.isNotEmpty) {
                    submitFeedback();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter feedback and email!")),
                    );
                  }
                },

                  child: Text("Send", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
