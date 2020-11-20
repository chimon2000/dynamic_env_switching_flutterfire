import 'dart:async';

import 'package:binder/binder.dart';
import 'package:dynamic_env_switching_flutterfire/business/repositories/authentication.repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authenticationStateRef =
    StateRef<AuthenticationState>(AuthenticationState.unknown());
final authenticationLogicRef = LogicRef((scope) => AuthenticationLogic(scope));

class AuthenticationLogic with Logic implements Disposable, Loadable {
  AuthenticationLogic(this.scope);

  @override
  final Scope scope;

  AuthenticationRepository get _authenticationRepository =>
      use(authenticationRepositoryRef);

  @override
  Future<void> load() async {
    _userSubscription = _authenticationRepository.user.listen((user) {
      var state = user == null
          ? AuthenticationState.unauthenticated()
          : AuthenticationState.authenticated(user);
      write<AuthenticationState>(authenticationStateRef, state);
    });
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    return await _authenticationRepository.signInWithEmailAndPassword(
      email,
      password,
    );
  }

  Future registerWithEmailAndPassword(
      String displayName, String email, String password) async {
    return await _authenticationRepository.registerWithEmailAndPassword(
      displayName,
      email,
      password,
    );
  }

  Future<void> signOut() async {
    return _authenticationRepository.signOut();
  }

  StreamSubscription<User> _userSubscription;
}

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
