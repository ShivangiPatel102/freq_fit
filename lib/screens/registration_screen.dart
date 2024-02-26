import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freq_fit/services/authentication.dart';

class RegisterScreen extends StatelessWidget {
  late String email;
  late String password;
  late String firstName;
  late String lastName;

  final _auth = FirebaseAuth.instance;
  final TextStyle sub = const TextStyle(
    fontWeight: FontWeight.w100,
    fontFamily: 'Blinker',
    fontSize: 20,
  );
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
              flex: 2,
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/appIcon.png',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: const Text(
                'Welcome',
                style: TextStyle(
                  fontFamily: 'Blinker',
                  fontWeight: FontWeight.w600,
                  fontSize: 50,
                  color: Color.fromRGBO(40, 51, 74, 1),
                ),
              ),
            ),
            const Spacer(),
            Expanded(
                child: TextField(
              decoration:
                  InputDecoration(hintText: 'Full Name', hintStyle: sub),
            )),
            const Spacer(),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    InputDecoration(hintText: 'Email ID', hintStyle: sub),
              ),
            ),
            const Spacer(),
            Expanded(
                child: TextField(
                  onChanged: (value) {
                  password = value;
                },
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password', hintStyle: sub),
            )),
            const Spacer(),
            Expanded(
                child: TextField(
              decoration: InputDecoration(
                hintText: 'Hospital / Clinic name ',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontFamily: 'Blinker',
                  fontSize: 20,
                ),
              ),
            )),
            const Spacer(),
            Expanded(
                child: TextField(
              decoration:
                  InputDecoration(hintText: 'Speciality ', hintStyle: sub),
            )),
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () async {
                  try {
                  final newUser = Authentication.registerUser(email, password);
                  if (newUser != null) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/home',
                    );
                  }
                } catch (e) {
                  print(e);
                }
                },
                child: Container(
                  padding: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(40, 51, 74, 1),
                  child: const Center(
                      child: Text('Register',
                          style: TextStyle(
                              fontFamily: 'Blinker',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700))),
                ),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Have an Account?",
                    style: TextStyle(
                        fontFamily: 'Blinker',
                        fontSize: 19.0,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Login!',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(
              flex: 6,
            ),
          ],
        ),
      ),
    );
  }
}
