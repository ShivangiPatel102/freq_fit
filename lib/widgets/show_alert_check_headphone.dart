import 'package:flutter/material.dart';

void show_Alert_Check_Headphone(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: const Color(0xff28334A) ,
          content: Container(
            height: 200,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(flex:2,child: Text('Kindly check whether the Headphones are plugged in.',style: TextStyle(fontFamily: 'Blinker',color: Colors.white,fontSize:20,fontWeight: FontWeight.bold),)),
               // const Spacer(flex: 1,),
                //Text('Headphones are plugged in.',style: alertText,),
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset('assets/icons/headset.png',fit: BoxFit.cover)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}