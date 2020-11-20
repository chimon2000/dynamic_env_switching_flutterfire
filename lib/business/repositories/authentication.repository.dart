import 'package:binder/binder.dart';
import 'package:dynamic_env_switching_flutterfire/business/repositories/profile.repository.dart';
import 'package:dynamic_env_switching_flutterfire/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authenticationRepositoryRef =
    LogicRef((scope) => AuthenticationRepository(scope));

class AuthenticationRepository with Logic {
  FirebaseAuth get _firebaseAuth => read(firebaseServiceRef).firebaseAuth;
  FirebaseService get _firebaseService => read(firebaseServiceRef);

  AuthenticationRepository(this.scope);

  @override
  final Scope scope;

  Stream<User> get user => _firebaseAuth.authStateChanges();

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = result.user;

      return user;
    } on FirebaseAuthException catch (error) {
      var errorMessage = _errorCodeMap[error.code];
      if (errorMessage != null) {
        return Future.error(errorMessage);
      }
    }
  }

  // register
  Future registerWithEmailAndPassword(
      String displayName, String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = result.user;
      await _profileRepository.updateRecord({
        "email": email,
        "displayName": displayName,
        'appName': _firebaseService.appName
      });

      return user;
    } catch (error) {
      var errorMessage = _errorCodeMap[error.code];

      if (errorMessage != null) {
        return Future.error(errorMessage);
      }
    }
  }

  // sign out
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  ProfileRepository get _profileRepository => use(profileRepositoryRef);
}

const _errorCodeMap = {
  'user-not-found':
      'There is no user record corresponding to this identifier. The user may have been deleted.',
  'invalid-email': 'Your email address appears to be malformed.',
  'wrong-password':
      'The password is invalid or the user does not have a password.',
  'user-disabled': 'User with this email has been disabled.',
  'too-many-requests': 'Too many requests. Try again later.',
  'email-already-in-use': 'The email is already in used by another account.',
  null: 'An undefined Error happened.',
};
