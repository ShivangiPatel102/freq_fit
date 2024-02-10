import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freq_fit/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    Future.delayed(const Duration(seconds: 2), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const Login(),),);
    });
  }
  
  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/logo.png'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Freq',style: TextStyle(fontFamily: 'Blinker',fontSize: 50,fontWeight: FontWeight.w700,color: Color.fromRGBO(40, 71, 74,1))),
                Text('Fit',style: TextStyle(fontFamily: 'Blinker',fontSize: 50,fontWeight: FontWeight.w700,color: Color.fromRGBO(220, 80, 73,1)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
