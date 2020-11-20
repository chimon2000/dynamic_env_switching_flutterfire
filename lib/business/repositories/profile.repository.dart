import 'package:binder/binder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_env_switching_flutterfire/business/models/profile.dart';
import 'package:dynamic_env_switching_flutterfire/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';

final profileRepositoryRef = LogicRef((scope) => ProfileRepository(scope));

class ProfileRepository with Logic {
  const ProfileRepository(this.scope);

  @override
  final Scope scope;

  Stream<Profile> get userProfile =>
      _userProfileRef.snapshots().map((event) => Profile.fromSnapshot(event));

  FirebaseAuth get _firebaseAuth => read(firebaseServiceRef).firebaseAuth;
  CollectionReference get _collection =>
      read(firebaseServiceRef).profileCollection;

  DocumentReference get _userProfileRef =>
      _collection.doc(_firebaseAuth.currentUser.uid);

  Future<void> updateRecord(Map<String, dynamic> data) async {
    return _userProfileRef.set(data, SetOptions(merge: true));
  }
}
