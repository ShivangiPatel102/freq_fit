import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsetsDirectional.only(start: 43.0,top: 32.0,end: 25.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/icons/appIcon.png',height:70,),
              ],
            ),
            const Text('Welcome', style: TextStyle(
              fontFamily: 'Blinker',
              fontWeight: FontWeight.w600,
              fontSize: 50,
              color: Color.fromRGBO(40, 51, 74,1),
            ),),

            const SizedBox(height: 30.0,),
            const Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: const TextField(decoration: InputDecoration(hintText: 'Full Name',hintStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w200), ),),
            ),
            const SizedBox(height: 10.0,),
            const Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: const TextField(decoration: InputDecoration(hintText: 'Email ID',hintStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w200), ),),
            ),

            const SizedBox(height: 10.0,),
            const Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: const TextField(decoration: InputDecoration(hintText: 'Hospital / Clinic name ',hintStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w200), ),),
            ),

            const SizedBox(height: 10.0,),
            const Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: const TextField(decoration: InputDecoration(hintText: 'Doctor ',hintStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w200), ),),
            ),

            const SizedBox(height: 25.0,),
            GestureDetector(
              child: Container(
                height: 38,
                padding: const EdgeInsetsDirectional.only(),
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(40, 51, 74, 1),
                child: const Center(child: Text('Register',style: TextStyle(fontFamily: 'Blinker',fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700))),
              ),
            ),
            const SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an Account?",style: TextStyle(fontFamily: 'Blinker',fontSize: 15.0,fontWeight: FontWeight.normal),),
                SizedBox(width: 5.0,),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/home') ;                   },
                  child: const Text('Login!',style: TextStyle(fontWeight: FontWeight.w700),),
                ),
              ],
            )


          ],
        ),

      ),
    );
  }
}
