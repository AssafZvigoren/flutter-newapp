import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseClient {
  static late FirebaseAuth _auth;

  static void initialize() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
  }

  static Future<UserCredential> login(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> register(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> logut() async {
    return _auth.signOut();
  }
}
