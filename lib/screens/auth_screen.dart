import 'package:flutter/material.dart';
import 'package:cravings1/services/auth_service.dart' as authService; // Assuming your package name
import 'package:cravings1/utils/constants.dart'; // Assuming constants.dart exists
// import 'package:cravings1/screens/main_screen.dart';

import '../main.dart'; // Assuming MainScreen is your home screen

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in all fields.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success;
    try {
      if (_isLogin) {
        success = await authService.AuthService.login(_emailController.text, _passwordController.text);
        if (success && authService.AuthService.currentUser != null) {
          await authService.AuthService.refreshUserData();
          final user = await authService.AuthService.getCurrentUserWithRole();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MainScreen(isAdmin: user?.isAdmin ?? false),
            ),
          );
        } else {
          setState(() {
            _errorMessage = "Login failed. Check your credentials.";
          });
        }
      } else {
        if (_nameController.text.isEmpty) {
          setState(() {
            _errorMessage = "Please enter your name for signup.";
            _isLoading = false;
          });
          return;
        }
        success = await authService.AuthService.signup(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        );
        if (success) {
          setState(() {
            _isLogin = true; // Switch to login mode after signup
            _errorMessage = "Signup successful! Please log in.";
            _emailController.clear();
            _passwordController.clear();
            _nameController.clear();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = "Signup failed. Try again.";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo or Title (Optional)
              const SizedBox(height: 40),
              const Text(
                "Cravings",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: kTextColor,
                ),
              ),
              const SizedBox(height: 40),

              // Form Fields
              if (!_isLogin)
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: kTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: TextStyle(color: kTextColor),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: kTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: kTextColor),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: kTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
                style: TextStyle(color: kTextColor),
              ),
              const SizedBox(height: 16),

              // Error Message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Submit Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
                  : ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isLogin ? "Login" : "Sign Up",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Toggle Between Login and Signup
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _errorMessage = null; // Clear error when switching
                  });
                },
                child: Text(
                  _isLogin
                      ? "Don’t have an account? Sign Up"
                      : "Already have an account? Login",
                  style: TextStyle(color: kPrimaryColor, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}