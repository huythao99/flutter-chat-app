import 'package:chat_app/src/common_widgets/loading/loading_widget.dart';
import 'package:chat_app/src/constants/dimensions_custom.dart';
import 'package:chat_app/src/constants/regex.dart';
import 'package:chat_app/src/constants/routes_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:chat_app/src/constants/regex.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _isLoading = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  void _toggle() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<void> _onPressSignin() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text, password: _pass.text);
      } catch (e) {
        final errorSnackBar = SnackBar(
          content: Text(e.toString()),
        );
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              toolbarHeight: 0,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.network(
                    'https://www.cjr.org/wp-content/uploads/2017/06/facebook-76536_1920.png',
                    height: DimensionsCustom.calculateHeight(26),
                    fit: BoxFit.cover,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: DimensionsCustom.calculateWidth(4),
                            vertical: DimensionsCustom.calculateHeight(1)),
                        child: TextFormField(
                          controller: _email,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter some text';
                            } else if (!RegexPattern.regexEmail
                                .hasMatch(value.trim())) {
                              return 'Please enter email correct';
                            }
                            return null;
                          },
                          keyboardAppearance: Brightness.dark,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter your email'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: DimensionsCustom.calculateWidth(4),
                            vertical: DimensionsCustom.calculateHeight(1)),
                        child: TextFormField(
                          controller: _pass,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter some text';
                            } else if (value.trim().length < 6) {
                              return 'Password must at least 6 characters';
                            } else if (value.trim().length > 32) {
                              return 'Password must be max 32 character';
                            }
                            return null;
                          },
                          keyboardAppearance: Brightness.dark,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: _toggle,
                                  icon: Padding(
                                      padding: EdgeInsets.only(
                                          top: DimensionsCustom.calculateHeight(
                                              2)),
                                      child: Icon(_showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off))),
                              border: const UnderlineInputBorder(),
                              labelText: 'Enter your password'),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: DimensionsCustom.calculateWidth(4),
                        vertical: DimensionsCustom.calculateHeight(2)),
                    child: ElevatedButton(
                      onPressed: _onPressSignin,
                      child: const Text('Login'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: DimensionsCustom.calculateWidth(4),
                        vertical: DimensionsCustom.calculateHeight(1)),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        Navigator.pushNamed(context, RouteConstant.routeSignup);
                      },
                      child: const Text('Signup'),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
