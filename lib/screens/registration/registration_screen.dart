import 'package:flutter/material.dart';
import 'package:leaf_n_lit/utilities/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Create text controllers to retrieve the text entered by the user
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  } // dispose()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Name
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
              obscureText: false,
              keyboardType: TextInputType.text,
              maxLength: 35,
              controller: nameController,
            ),

            // const SizedBox(height: 16.0),

            // Email
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
            ),

            const SizedBox(height: 16.0),

            // Password
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
              controller: passwordController,
            ),

            const SizedBox(height: 16.0),

            // Confirm Password
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
              obscureText: true,
              controller: confirmPasswordController,
            ),

            const SizedBox(height: 16.0),

            // Register button
            ElevatedButton(
              onPressed: registerPressed,
              child: const Text('Register'),
            ),

            const SizedBox(height: 16.0),

            // Display error
            Center(
              child: Text(
                _errorMessage ?? '',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }

// registration_screen.dart (in RegistrationScreen widget)

  void registerPressed() async {
    print('Register button pressed');
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    AuthService authService = AuthService();

    // Attempt to register the user
    String? createUserWithEmailAndPasswordResult =
        await authService.createUserWithEmailAndPassword(email, password);

    if (createUserWithEmailAndPasswordResult == null) {
      // Registration was successful

      // Send email verification
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && !currentUser.emailVerified) {
        await currentUser.sendEmailVerification();
        setState(() {
          _errorMessage = "Verification email has been sent! check your inbox.";
        });
      }

      // Navigate to home if needed
      // GoRouter.of(context).go('/home');
    } else {
      // Registration failed
      setState(() {
        _errorMessage = createUserWithEmailAndPasswordResult;
      });
    }
  }
}
