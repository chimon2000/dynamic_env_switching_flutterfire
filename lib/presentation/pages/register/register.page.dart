import 'package:binder/binder.dart';
import 'package:dynamic_env_switching_flutterfire/presentation/logic/logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage();

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (context) {
      return RegisterPage();
    });
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Text Field State
  String displayName = '';
  String email = '';
  String password = '';
  String error = '';
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: FlutterLogo(size: 100),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text('Welcome!'),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                      enableSuggestions: false,
                      controller: _email,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      onChanged: (input) {
                        setState(() => email = input);
                      }),
                  SizedBox(height: 20.0),
                  TextFormField(
                    enableSuggestions: false,
                    obscureText: _obscureText,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorMaxLines: 1,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: _toggle,
                        color: Colors.grey,
                      ),
                    ),
                    validator: _validatePassword,
                    onChanged: (input) {
                      setState(() => password = input);
                    },
                  ),
                  Spacer(),
                  OutlineButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          await context
                              .use(authenticationLogicRef)
                              .registerWithEmailAndPassword(
                                  displayName, email, password);
                        } catch (e) {
                          _showAlert(e);
                        }
                      }
                    },
                    child: Text("Sign up"),
                  ),
                  SizedBox(height: 20.0),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Existing account?'),
                    SizedBox(width: 3),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Login',
                      ),
                    )
                  ]),
                ],
              ),
            )),
      ),
    );
  }

  void _showAlert(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(error.toString()),
      duration: Duration(seconds: 1),
    ));
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Password validation
  String _validatePassword(String value) =>
      value.isEmpty ? 'Please enter a password' : null;

  String _validateEmail(String value) =>
      EmailValidator.validate(value) ? null : 'Please enter a valid email.';
}
