import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget  {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      appBar: AppBar(
        title: const Text('FreqFit'),
        backgroundColor: Colors.amber,
      ),

      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: const EdgeInsets.all(10.0),
          children: [
             DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(onTap: (){Navigator.pop(context);},
                  child: const Icon(Icons.arrow_back),
                  ),
                  const Text('FreqFit',style: TextStyle(fontFamily: 'Blinker',fontSize: 50,fontWeight: FontWeight.w700,color: Color.fromRGBO(40, 71, 74,1))),
                ],
              ),
            ),
            ListTile(
              leading: Image.asset('assets/icons/home.png',height: 20.0),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),

            ListTile(
              leading: Image.asset('assets/icons/checklist.png',height: 19.0),
              title: const Text('Trial Test'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),

            ListTile(
              leading: Image.asset('assets/icons/pta.png',height: 20.0),
              title: const Text('PTA Test'),
              onTap: () {
                Navigator.pushNamed(context, '/ptaTest');
              },
            ),

            ListTile(
              leading: Image.asset('assets/icons/books.png',height: 20.0),
              title: const Text('Tutorials'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),

            ListTile(
              leading: Image.asset('assets/icons/notepad.png',height: 20.0,),
              title: const Text('History'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),

            ListTile(
              leading: Image.asset('assets/icons/profile.png',height: 20.0,),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),

          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(42.0),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25.0,),
            const Text('What do you need?',style: TextStyle(fontFamily: 'Blinker',fontSize: 20,fontWeight: FontWeight.w400
            ),),

            const SizedBox(height: 25.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               SmallCard(
                 imagePath: 'assets/icons/checklist.png', // Specify the path to your image asset
                 text: 'Trial Test',
                 onTap: (){},
               ),

               SmallCard(
                 imagePath: 'assets/icons/pta.png', // Specify the path to your image asset
                 text: 'PTA Test',
                 onTap: (){
                   Navigator.pushNamed(context, '/ptaTest');
                 },
               ),

          ],
            ),

            const SizedBox(height: 25,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmallCard(
                  imagePath: 'assets/icons/books.png', // Specify the path to your image asset
                  text: 'Tutorials',
                  onTap: (){},
                ),

                SmallCard(
                  imagePath: 'assets/icons/notepad.png', // Specify the path to your image asset
                  text: 'History',
                  onTap: (){},
                ),

              ],
            ),

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
              Text(text, style: const TextStyle(fontSize: 16.0,fontFamily: 'Rubik',color: Color.fromRGBO(40, 51, 74, 1))),
            ],
          ),
        ),
      ),
    );
  }
}

