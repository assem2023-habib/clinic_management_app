import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  bool get isSignedIn => _auth.currentUser != null;
  String? get uid => _auth.currentUser?.uid;

  Future<void> signInWithCustomToken(String customToken) async {
    await _auth.signInWithCustomToken(customToken);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  DatabaseReference ref(String path) => _database.ref(path);

  Future<Map<String, dynamic>?> readOnce(String path) async {
    final snapshot = await _database.ref(path).once();
    return snapshot.snapshot.value as Map<String, dynamic>?;
  }

  Stream<DatabaseEvent> observe(String path) {
    return _database.ref(path).onValue;
  }
}
