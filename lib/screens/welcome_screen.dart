import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              child: Text('Login'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlueAccent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 15.0))),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: Text('Register'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15.0))))
          ],
        ),
      ),
    );
  }
}
