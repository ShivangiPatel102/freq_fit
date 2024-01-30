import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  final TextStyle small = const TextStyle(fontWeight: FontWeight.w100,fontFamily: 'Blinker',fontSize: 20);
  final TextStyle large = const TextStyle(fontFamily: 'Blinker', fontWeight: FontWeight.w600, fontSize: 50, color: Color.fromRGBO(40, 51, 74,1),);
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
               Text('Welcome', style: large),

               Text('Back', style: large),

              const SizedBox(height: 30.0,),

                Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child:  TextField(decoration: InputDecoration(hintText: 'Username or e-mail',hintStyle: small ),),
              ),

              const SizedBox(height: 30.0,),

                Padding(
                padding:  const EdgeInsets.only(right: 15.0),
                child:  TextField(decoration: InputDecoration(hintText: 'Password',hintStyle: small ),),
              ),

               Row(
                mainAxisAlignment: MainAxisAlignment.end ,
                children: [
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(end: 25.0,top: 10.0),
                        child: const Text('Forgot Password?',style: TextStyle(fontFamily: 'Blinker',fontWeight: FontWeight.w700))),
                  ),
                ],
              ),

              const SizedBox(height: 25.0,),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/home') ;
                },
                child: Container(
                  height: 38,
                  padding: const EdgeInsetsDirectional.only(),
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(40, 51, 74, 1),
                  child: const Center(child: Text('Login',style: TextStyle(fontFamily: 'Blinker',fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700))),
                ),
              ),

              const SizedBox(height: 30.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Don't have an Account?",style: small),
                  const SizedBox(width: 5.0,),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register') ;                   },
                    child: const Text('Register!!',style: TextStyle(fontWeight: FontWeight.w700),),
                  ),


                ],
              )


            ],
          ),

      ),
    );
  }
}
