import 'package:flutter/material.dart';

void show_Alert_Check_Headphone(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xff28334A) ,
        content: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kindly check whether the Headphones are plugged in.',style: TextStyle(fontFamily: 'Blinker',color: Colors.white,fontSize:20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 25.0,),
              //Text('Headphones are plugged in.',style: alertText,),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset('assets/icons/headset.png', height: 111,width:120,fit: BoxFit.cover)),
            ],
          ),
        ),
      );
    },
  );
}