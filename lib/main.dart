import 'package:binder/binder.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/logic/logic.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/pages/pages.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(BinderScope(child: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, child) => StateListener<AuthenticationState>(
        watchable: authenticationStateRef,
        onStateChanged: (context, authState) {
          if (authState.status == AuthenticationStatus.unauthenticated) {
            _navigator.pushAndRemoveUntil(
              LoginPage.route(),
              (route) => false,
            );
          } else {
            _navigator.pushAndRemoveUntil(
              HomePage.route(),
              (route) => false,
            );
          }
        },
        child: Root(child: child),
      ),
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
