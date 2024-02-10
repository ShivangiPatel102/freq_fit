import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  final TextStyle sub = const TextStyle(fontWeight: FontWeight.w100,fontFamily: 'Blinker',fontSize: 20,);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsetsDirectional.only(start: 25.0,end: 25.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 2,),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/icons/appIcon.png',height:70,),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: const Text('Welcome', style: TextStyle(
                fontFamily: 'Blinker',
                fontWeight: FontWeight.w600,
                fontSize: 50,
                color: Color.fromRGBO(40, 51, 74,1),
              ),),
            ),

            const Spacer(),

             Expanded(child: TextField(decoration: InputDecoration(hintText: 'Full Name',hintStyle: sub ),)),

            const Spacer(),

             Expanded(child: TextField(decoration: InputDecoration(hintText: 'Email ID',hintStyle: sub ),)),

            const Spacer(),

            Expanded(child: TextField(decoration: InputDecoration(hintText: 'Hospital / Clinic name ',hintStyle: TextStyle(fontWeight: FontWeight.w100,fontFamily: 'Blinker',fontSize: 20,), ),)),

            const Spacer(),

             Expanded(child: TextField(decoration: InputDecoration(hintText: 'Doctor ',hintStyle: sub ),)),

            const Spacer(),

            Expanded(
              child: GestureDetector(
                child: Container(
                  height: 38,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(40, 51, 74, 1),
                  child: const Center(child: Text('Register',style: TextStyle(fontFamily: 'Blinker',fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700))),
                ),
              ),
            ),
            const Spacer(),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have an Account?",style: TextStyle(fontFamily: 'Blinker',fontSize: 15.0,fontWeight: FontWeight.normal),),
                  const SizedBox(width: 5.0,),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login') ;                   },
                    child: const Text('Login!',style: TextStyle(fontWeight: FontWeight.w700),),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 5,),


          ],
        ),

      ),
    );
  }
}
