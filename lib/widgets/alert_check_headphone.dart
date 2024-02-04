import 'package:flutter/material.dart';

class alert_check_headphone extends StatelessWidget {
  const alert_check_headphone({super.key});

  final TextStyle alertText = const TextStyle(color: Colors.white,fontFamily: 'Blinker',fontWeight: FontWeight.bold,fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff28334A) ,
      content: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kindly check whether the Headphones are plugged in.',style: alertText ),
            const SizedBox(height: 25.0,),
            //Text('Headphones are plugged in.',style: alertText,),
            ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset('assets/icons/headset.png', height: 111,width:120,fit: BoxFit.cover,)),
          ],
        ),
      ),

    );
  }
}
