import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String email;
  final String appName;

  Profile({
    this.id,
    this.email,
    this.appName,
  });

  factory Profile.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    return Profile(
      id: snapshot.id,
      email: data['email'],
      appName: data['appName'],
    );
  }

  @override
  List<Object> get props => [id, email, appName];

  @override
  bool get stringify => true;

  Profile copyWith({
    String id,
    String email,
    String appName,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      appName: appName ?? this.appName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'appName': appName,
    };
  }
}
