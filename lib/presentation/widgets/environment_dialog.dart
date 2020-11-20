import 'package:dynamic_env_switching_flutterfire/data/data.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_env_switching_flutterfire/common/common.dart';

class EnvironmentDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Select environment'),
      children: _buildSimpleDialog(Environment.values, context),
    );
  }
}

List<Widget> _buildSimpleDialog(List<Environment> envs, BuildContext context) {
  var list = <Widget>[];
  envs.forEach((env) {
    list.add(
      SimpleDialogOption(
        child: Text(
          env.toString().enumName.toUpperCase(),
        ),
        onPressed: () {
          Navigator.pop(context, env);
        },
      ),
    );
  });

  return list;
}
