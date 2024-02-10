import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  final TextStyle small = const TextStyle(fontWeight: FontWeight.w100,fontFamily: 'Blinker',fontSize: 20);
  final TextStyle large = const TextStyle(fontFamily: 'Blinker', fontWeight: FontWeight.w600, fontSize: 50, color: Color.fromRGBO(40, 51, 74,1),);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsetsDirectional.only(start: 25.0,end: 25.0),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1,),
              Expanded(
                flex:2,child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset('assets/icons/appIcon.png',),
                  ],
                ),
              ),
               const Spacer(),
               Expanded(flex:2,child: Text('Welcome', style: large)),

               Expanded(flex:2,child: Text('Back', style: large)),

                const Spacer(),

                Expanded(flex:2,child: TextField(decoration: InputDecoration(hintText: 'Username or e-mail',hintStyle: small ),)),

                Expanded(flex:2,child: TextField(decoration: InputDecoration(hintText: 'Password',hintStyle: small ),)),

               Expanded(
                 flex: 1,
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.end ,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsetsDirectional.only(end: 25.0),
                          child: const Text('Forgot Password?',style: TextStyle(fontFamily: 'Blinker',fontWeight: FontWeight.w700))),
                    ),
                  ],
                               ),
               ),

              
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/home') ;
                  },
                  child: Container(
                    color: const Color.fromRGBO(40, 51, 74, 1),
                    child: const Center(child: Text('Login',style: TextStyle(fontFamily: 'Blinker',fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700))),
                  ),
                ),
              ),


              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text("Don't have an Account?",style: small),
                    
                
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register') ;                   },
                      child: const Text('Register!!',style: TextStyle(fontWeight: FontWeight.w700),),
                    ),
                
                
                  ],
                ),
              ),

              const Spacer(flex: 10,),
            ],
          ),

      ),
    );
  }
}
