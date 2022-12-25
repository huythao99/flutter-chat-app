import 'package:chat_app/src/common_widgets/loading/loading_widget.dart';
import 'package:chat_app/src/constants/dimensions_custom.dart';
import 'package:chat_app/src/constants/routes_constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/src/constants/regex.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  SignupScreenState createState() {
    return SignupScreenState();
  }
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _showRePassword = false;
  bool _isLoading = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  void _toggle() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleRePassword() {
    setState(() {
      _showRePassword = !_showRePassword;
    });
  }

  Future<void> _onPressSignup() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.text, password: _pass.text);
        FirebaseAuth.instance.currentUser
            ?.updateDisplayName(_email.text.split('@')[0]);
        FirebaseFirestore.instance.collection('users').add({
          'full_name': _email.text.split('@')[0], // John Doe
        });
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              RouteConstant.routeHome, (route) => false);
        }
      }
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
                      'https://www.cjr.org/wp-content/uploads/2017/06/facebook-76536_1920.png'),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: DimensionsCustom.calculateWidth(4),
                            vertical: DimensionsCustom.calculateHeight(1)),
                        child: TextFormField(
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
                          controller: _email,
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
                          controller: _pass,
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: DimensionsCustom.calculateWidth(4),
                            vertical: DimensionsCustom.calculateHeight(1)),
                        child: TextFormField(
                          validator: (value) {
                            if (value != _pass.text) {
                              return 'Confirm password must be equal password';
                            }
                            return null;
                          },
                          keyboardAppearance: Brightness.dark,
                          obscureText: !_showRePassword,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: _toggleRePassword,
                                  icon: Padding(
                                      padding: EdgeInsets.only(
                                          top: DimensionsCustom.calculateHeight(
                                              2)),
                                      child: Icon(_showRePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off))),
                              border: const UnderlineInputBorder(),
                              labelText: 'Enter your repassword'),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: DimensionsCustom.calculateWidth(4),
                        vertical: DimensionsCustom.calculateHeight(1)),
                    child: ElevatedButton(
                      onPressed: _onPressSignup,
                      child: const Text('Signup'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: DimensionsCustom.calculateWidth(4),
                        vertical: DimensionsCustom.calculateHeight(1)),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        Navigator.pop(context);
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
