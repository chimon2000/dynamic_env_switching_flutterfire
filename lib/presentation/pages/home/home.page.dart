import 'package:dynamic_env_switching_flutterfire/business/business.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/logic/home.logic.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/logic/logic.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:binder/binder.dart';

class HomePage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (context) {
      return LogicLoader(refs: [homeLogicRef], child: HomePage());
    });
  }

  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProfile = context.watch(userProfileRef);
    var loading = Container();
    var summary = _buildSummary(userProfile);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AnimatedSwitcher(
                switchInCurve: Curves.easeInToLinear,
                duration: Duration(milliseconds: 500),
                child: userProfile == null ? loading : summary,
              ),
            ),
            ButtonBar(
              children: [
                ChangeEnvironmentButton(),
                FlatButton(
                    onPressed: () =>
                        context.use(authenticationLogicRef).signOut(),
                    child: Text('Sign out'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(Profile userProfile) => userProfile == null
      ? SizedBox.shrink()
      : ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('Email'),
              subtitle: Text(userProfile.email),
            ),
            ListTile(
              title: Text('App name'),
              subtitle: Text(userProfile.appName),
            )
          ],
        );
}
