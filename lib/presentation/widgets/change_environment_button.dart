import 'package:dynamic_env_switching_flutterfire/data/data.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/logic/logic.dart';
import 'package:flutter/material.dart';
import 'package:binder/binder.dart';

import 'environment_dialog.dart';

class ChangeEnvironmentButton extends StatelessWidget {
  const ChangeEnvironmentButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.transparent,
      child: Text(
        "Change Environment",
        style: TextStyle(
            color: Colors.black87,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500),
      ),
      onPressed: () async {
        var environment = await showDialog<Environment>(
            context: context,
            builder: (context) {
              return EnvironmentDialog();
            });

        if (environment != null) {
          context.use(appLogicRef).changeEnvironment(environment);
        }
      },
    );
  }
}
