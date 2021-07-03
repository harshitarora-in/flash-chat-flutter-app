import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/roundedelevatedbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 130.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your Email')),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your Password')),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedElevatedButton(
                      color: Colors.lightBlueAccent,
                      buttonText: 'Login',
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          Navigator.pushNamed(context, ChatScreen.id);
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
