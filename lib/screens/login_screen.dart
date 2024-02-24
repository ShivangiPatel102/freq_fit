import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsetsDirectional.only(start: 25.0, end: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/icons/appIcon.png',
                  ),
                ],
              ),
            ),
            const Spacer(),
            Expanded(flex: 2, child: Text('Welcome', style: large)),
            Expanded(flex: 2, child: Text('Back', style: large)),
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'E-mail Address', hintStyle: small),
                ),
              ),
            ),
            // password
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: small,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Forgot password
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: const EdgeInsetsDirectional.only(end: 25.0),
                        child: const Text('Forgot Password?',
                            style: TextStyle(
                                fontFamily: 'Blinker',
                                fontWeight: FontWeight.w700))),
                  ),
                ],
              ),
            ),
            Spacer(),
            // Login Button
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  // Add a 2-second delay using Future.delayed
                  Future.delayed(Duration(seconds: 2), () {
                    // Code to be executed after the delay
                    // For example, you can navigate to another screen
                    Navigator.pushNamed(context, '/home');
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  color: const Color.fromRGBO(40, 51, 74, 1),
                  child: const Center(
                      child: Text('Login',
                          style: TextStyle(
                              fontFamily: 'Blinker',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700))),
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            //Dont have account register
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account? ",
                    style: const TextStyle(
                        fontWeight: FontWeight.w100,
                        fontFamily: 'Blinker',
                        fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Register!!',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
