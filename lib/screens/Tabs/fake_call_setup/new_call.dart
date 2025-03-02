import 'package:flutter/material.dart';

class NewCallPage extends StatefulWidget {
  @override
  _NewCallPageState createState() => _NewCallPageState();
}

class _NewCallPageState extends State<NewCallPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        keyboardType: label == "Phone Number" || label == "Duration"
            ? TextInputType.number
            : TextInputType.text,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String phone = _phoneController.text;
      String duration = _durationController.text;
      Navigator.of(context).pop();
      // Process the form data (e.g., schedule a fake call)
      print("Fake Call Scheduled: $name, $phone, Duration: $duration seconds");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fake call scheduled successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Fake Call")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, "Name", Icons.person),
              _buildTextField(_phoneController, "Phone Number", Icons.phone),
              _buildTextField(_durationController, "Duration", Icons.timer),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}