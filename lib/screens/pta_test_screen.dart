import 'package:flutter/material.dart';

class PtaTestScreen extends StatelessWidget {
  const PtaTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('PTA Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter Patient Name',
                hintStyle: const TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.w400,color: Color.fromRGBO(40, 51, 74, 1),),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),

            const SizedBox(height: 25.0,),

            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter Patient Email',
                hintStyle: const TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.w400,color: Color.fromRGBO(40, 51, 74, 1),),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),

            const SizedBox(height: 25.0,),

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home') ;
              },
              child: Container(
                height: 38,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(40, 51, 74, 1),
                child: const Center(child: Text('Register',style: TextStyle(fontFamily: 'Blinker',fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700))),
              ),
            ),

            const SizedBox(height: 35.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallCard(imagePath: 'assets/icons/puretone.png', text: 'Pure Tone', onTap: (){}),
                //SmallCard(imagePath: 'assets/icons/boneConduct.png', text: 'Bone Conduct', onTap: (){}),
              ],
            )

          ],
        ),
      ),
    );
  }
}



class SmallCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap; // Add this line if you want the card to be tappable

  const SmallCard({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onTap, // Add this argument if needed
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 126,
        height: 151,
        decoration:  BoxDecoration(

          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [BoxShadow(color: Color(0xfffdfcfc), spreadRadius: 1.0, blurRadius: 3.0)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(imagePath, width: 80.0, height: 80.0, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10.0),
              Text(text, style: const TextStyle(fontFamily: 'Rubik',color: Color.fromRGBO(40, 51, 74, 1))),
            ],
          ),
        ),
      ),
    );
  }
}
