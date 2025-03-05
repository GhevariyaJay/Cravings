import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../services/auth_service.dart' as authService;
// Alias for services/auth_service.dart
import '../models/user.dart'; // Import your custom User model
import 'auth_screen.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = authService.AuthService.currentUser; // Use aliased AuthService
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(kPadding * 2),
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.15, // Responsive avatar size
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: screenWidth * 0.1,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: kPadding),
                    Text(
                      user!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: kPadding / 2),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Content
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile Info Card
                        Card(
                          elevation: kCardElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Account Details",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: kTextColor,
                                  ),
                                ),
                                const SizedBox(height: kPadding),
                                _buildInfoRow("Name", user.name, Icons.person),
                                _buildInfoRow("Email", user.email, Icons.email),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: kPadding),

                        // Actions Card
                        Card(
                          elevation: kCardElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kPadding),
                            child: Column(
                              children: [
                                _buildActionTile(
                                  context,
                                  "Edit Profile",
                                  Icons.edit,
                                      () => _showEditProfileDialog(context, user),
                                ),
                                const Divider(),
                                _buildActionTile(
                                  context,
                                  "Logout",
                                  Icons.logout,
                                      () {
                                    authService.AuthService.logout(); // Use aliased AuthService
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                                    );
                                  },
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for info rows
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kPadding / 2),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor, size: 24),
          const SizedBox(width: kPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: kTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget for action tiles
  Widget _buildActionTile(BuildContext context, String title, IconData icon, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? kPrimaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: color ?? kTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  // Edit Profile Dialog
  void _showEditProfileDialog(BuildContext context, User user) {
    final _nameController = TextEditingController(text: user.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Edit Profile", style: TextStyle(color: kTextColor)),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Full Name",
              prefixIcon: const Icon(Icons.person, color: kPrimaryColor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = _nameController.text.trim();
                if (newName.isNotEmpty && newName != user.name) {
                  try {
                    // Update Firebase Authentication
                    await firebase_auth.FirebaseAuth.instance.currentUser!.updateDisplayName(newName);

                    // Update Firestore
                    await firestore.FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.id)
                        .set({'name': newName, 'email': user.email}, firestore.SetOptions(merge: true));

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile updated successfully")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to update profile: $e")),
                    );
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}