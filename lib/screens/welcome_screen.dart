import 'package:flutter/material.dart';
import 'package:messageme_app/screens/auth_screen.dart';

import '../widgets/designs/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String screenRoute = 'welcome_screen';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  child: Image.asset('images/logo.png'),
                ),
                Text(
                  'MessageMe',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff2A356B),
                  ),
                ),
                SizedBox(height: 30),
                MyButtun(
                  color: Color(0xffFEAA2E),
                  title: 'Sign in',
                  onpressed: () {
                    Navigator.pushNamed(context, AuthScreen.screenRoute,
                        arguments: true);
                  },
                ),
                MyButtun(
                  color: Color(0xff0B6EF1),
                  title: 'Register',
                  onpressed: () {
                    Navigator.pushNamed(context, AuthScreen.screenRoute,
                        arguments: false);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
