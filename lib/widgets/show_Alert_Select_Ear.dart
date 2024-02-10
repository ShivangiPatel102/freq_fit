import 'package:flutter/material.dart';
import 'package:freq_fit/screens/pure_tone_screen.dart';

int show_Alert_Select_Ear(BuildContext context) {
  int bal=0;
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
              const Text('Select Ear.',style: TextStyle(fontSize: 30.0,fontFamily: 'Blinker',color: Colors.white,fontWeight: FontWeight.bold), ),
              const SizedBox(height: 25.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      bal=0;
                      Navigator.pop(context);

                    },
                    child: Container(
                      height: 83,
                      width: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xffDC5049),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Center(child: Text('L',style: TextStyle(fontFamily: 'Blinker',fontWeight: FontWeight.bold,fontSize: 40,color: Colors.white),)),
                    ),
                  ),

                  const SizedBox(width: 20.0,),

                  GestureDetector(
                    onTap:(){
                      bal=1;
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 83,
                      width: 90,
                      decoration: BoxDecoration(
                        color:  Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Center(child: Text('R',style: TextStyle(fontFamily: 'Blinker',fontWeight: FontWeight.bold,fontSize: 40,color: Color(0xffDC5049)),)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return bal;
}
