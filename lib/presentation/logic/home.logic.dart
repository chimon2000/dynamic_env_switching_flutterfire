import 'dart:async';

import 'package:binder/binder.dart';
import 'package:dynamic_env_switching_flutterfire/business/business.dart';
import 'package:dynamic_env_switching_flutterfire/business/models/profile.dart';

final userProfileRef = StateRef<Profile>(null);
final homeLogicRef = LogicRef((scope) => HomeLogic(scope));

class HomeLogic with Logic implements Loadable, Disposable {
  HomeLogic(this.scope);

  @override
  final Scope scope;

  ProfileRepository get _profileRepository => use(profileRepositoryRef);

  @override
  Future<void> load() async {
    _userProfileSubscription = _profileRepository.userProfile.listen((user) {
      write(userProfileRef, user);
    });
  }

  @override
  void dispose() {
    _userProfileSubscription?.cancel();
  }

  StreamSubscription<Profile> _userProfileSubscription;
}
