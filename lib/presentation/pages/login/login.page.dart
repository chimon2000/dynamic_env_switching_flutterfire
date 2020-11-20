import 'package:dynamic_env_switching_flutterfire/data/data.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/logic/logic.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/pages/pages.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/widgets/environment_dialog.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/widgets/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:binder/binder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (context) {
      return LoginPage();
    });
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Text Field State
  String email = '';
  String password = '';
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: FlutterLogo(size: 100),
                ),
                SizedBox(height: 20),
                Center(child: Text('Welcome!')),
                SizedBox(height: 40),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (input) => EmailValidator.validate(input)
                        ? null
                        : 'Please enter a valid email',
                    onChanged: (input) {
                      setState(() => email = input);
                    }),
                SizedBox(height: 15),
                TextFormField(
                  enableSuggestions: false,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: _toggle,
                      color: Colors.grey,
                    ),
                  ),
                  validator: (input) =>
                      input.isEmpty ? 'Please enter a password.' : null,
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                ),
                ChangeEnvironmentButton(),
                Spacer(),
                OutlineButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        await context
                            .use(authenticationLogicRef)
                            .signInWithEmailAndPassword(email, password);
                      } catch (error) {
                        showAlert(error);
                      }
                    }
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("No account?"),
                  SizedBox(width: 3),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).push(RegisterPage.route()),
                    child: Text('Register'),
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAlert(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(error.toString()),
      duration: Duration(seconds: 1),
    ));
  }
}
