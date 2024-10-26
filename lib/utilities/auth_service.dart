// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  /* Stream<User?> authStateChanges => FirebaseAuth.instance.authStateChanges();
  - authStateChanges() listens to authentication state changes like login and logout.
  - You can use this stream to update the UI on your screen when the user logs in or logs out
  - I think this will eventually be changed to userChanges() rather than authStateChanges()...
    but for now this will do.
  */
  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  // Create account with email and password
  Future<String?> createUserWithEmailAndPassword(String email, String password) async {
    try { // If the operation is successful, the user will be signed in and the user's information will be returned in the UserCredential object which we can use.
      
      // We could preform additional tasks here, like storing user data in a database, but for now we will just return the userCredential object.

      return null; // Return user credential to caller
    
    } on FirebaseAuthException catch (e) { // Error handling
      if (e.code == "weak-password") {
        return "The password provided is too weak.";
      } else if (e.code == "email-already-in-use") {
        return "The account already exists for that email.";
      } else {
        return e.message;
      }
    } catch (e) { // Catch any other generic error
        return e.toString();
    }
  }

  // Login with email and password
  Future<UserCredential?> signInWithEmailAndPassword (String email, String password) async {
    try {
      // on success
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return userCredential; // Return user credential if login is successful
    } on FirebaseAuthException catch (e) {
      // on error
      print("Failed with error code: ${e.code}");
      print(e.message);
      return null; // Return null if login fails
    }
  }
}