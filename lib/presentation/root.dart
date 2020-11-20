import 'package:binder/binder.dart';
import 'package:dynamic_env_switching_flutterfire/data/data.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/logic/logic.dart';
import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  const Root({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StateListener<String>(
      watchable: firebaseServiceRef.select((state) => state.appName),
      onStateChanged: (context, name) {
        context.use(authenticationLogicRef).load();
      },
      child: LogicLoader(
        refs: [authenticationLogicRef],
        child: child,
      ),
    );
  }
}
