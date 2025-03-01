import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:aura/widgets/homepage.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _gender = "Female"; 
  File? _image;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final cloudinary = CloudinaryPublic('dykk3ngmx', 'flutter_upload', cache: false);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return null;
    try {
      setState(() {
        _isUploading = true;
      });

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_image!.path, resourceType: CloudinaryResourceType.Image),
      );

      return response.secureUrl;
    } catch (e) {
      print("Image upload error: $e");
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your name and select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? imageUrl = await _uploadImage();
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to upload image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not authenticated"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _firestore.collection("users").doc(userId).set({
        "userId": userId,
        "name": _nameController.text.trim(),
        "gender": _gender,
        "imageUrl": imageUrl,
        "profileCompleted": true, // Ensures user is marked as completed
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Merging to avoid overwriting

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } catch (e) {
      print("Firestore error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to save profile"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "AURA",
          style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.secondary.withOpacity(0.3),
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, color: theme.colorScheme.onSecondary, size: 30)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text("Name", style: theme.textTheme.bodyLarge),
              const SizedBox(height: 5),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 20),
              Text("Gender", style: theme.textTheme.bodyLarge),
              Row(
                children: [
                  _buildRadio("Female"),
                  _buildRadio("Male"),
                  _buildRadio("Other"),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isUploading
                      ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                      : Text("Submit", style: TextStyle(color: theme.colorScheme.onPrimary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: _gender,
          onChanged: (val) {
            setState(() {
              _gender = val.toString();
            });
          },
        ),
        Text(value),
      ],
    );
  }
}
