import 'package:dynamic_env_switching_flutterfire/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';
import 'package:binder/binder.dart';
import 'package:equatable/equatable.dart';
import 'package:dynamic_env_switching_flutterfire/common/common.dart';

final appLogicRef = LogicRef((scope) => AppLogic(scope));
final appStateRef = StateRef(AppState.intial());

class AppLogic with Logic {
  const AppLogic(this.scope);

  @override
  final Scope scope;

  void changeEnvironment(Environment environment) async {
    if (!Firebase.apps.any((e) => e.name == environment.toString().enumName)) {
      await Firebase.initializeApp(
        name: environment.toString().enumName,
        options: stagingOptions,
      );
    }

    if (read(appStateRef).environment != environment) {
      Firebase.apps.forEach((app) {
        FirebaseAuth.instanceFor(app: app).signOut();
      });
    }

    setEnvironment(environment);
  }

  void setEnvironment(Environment environment) {
    write(appStateRef, read(appStateRef).copyWith(environment: environment));
    write(firebaseServiceRef, FirebaseService(firebaseAppNameMap[environment]));
  }
}

@immutable
class AppState extends Equatable {
  final Environment environment;
  final debugEnabled = Application.enableDebug;

  AppState({this.environment = Environment.prod});

  AppState.intial() : environment = Environment.prod;

  @override
  List<Object> get props => [environment];

  AppState copyWith({
    Environment environment,
  }) {
    return AppState(
      environment: environment ?? this.environment,
    );
  }
}

final firebaseAppNameMap = {
  Environment.prod: '[DEFAULT]',
  Environment.staging: Environment.staging.toString().enumName,
  null: '[DEFAULT]'
};

/// IMPORTANT: Set as environment variables using dart defines.
const stagingOptions = const FirebaseOptions(
  appId: const String.fromEnvironment('STAGING_APP_ID'),
  apiKey: const String.fromEnvironment('STAGING_APP_KEY'),
  projectId: const String.fromEnvironment('STAGING_PROJECT_ID'),
  messagingSenderId: const String.fromEnvironment('STAGING_PROJECT_NUMBER'),
);
