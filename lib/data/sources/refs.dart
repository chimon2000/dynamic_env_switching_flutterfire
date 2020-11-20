import 'package:binder/binder.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final firebaseServiceRef = StateRef(FirebaseService());

class FirebaseService extends Equatable {
  FirebaseService([this.appName = defaultFirebaseAppName]);

  final String appName;

  FirebaseAuth get firebaseAuth => FirebaseAuth.instanceFor(app: _firebaseApp);

  CollectionReference get profileCollection =>
      _firestore.collection('profiles');

  @override
  List<Object> get props => [appName];

  FirebaseApp get _firebaseApp => Firebase.app(appName);
  FirebaseFirestore get _firestore =>
      FirebaseFirestore.instanceFor(app: _firebaseApp);
}
