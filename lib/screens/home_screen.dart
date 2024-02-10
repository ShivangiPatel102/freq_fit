import 'package:flutter/material.dart';
import 'package:freq_fit/widgets/app_bar.dart';
import 'package:freq_fit/widgets/my_drawer.dart';
import 'package:freq_fit/widgets/card.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80), 
        child: AppBarCustom(),
      ),
      drawer: MyDrawer(),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 1,),
          Expanded(
            flex: 1,
            child: const Text(
              'What do you need?',
              style: TextStyle(
                  fontFamily: 'Blinker',
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),

          const Spacer(),

          Expanded(
            flex: 5,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),

                Expanded(
                  child: SmallCard(
                    imagePath:
                        'assets/icons/checklist.png', // Specify the path to your image asset
                    text: 'Trial Test',
                    onTap: () {},
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: SmallCard(
                    imagePath:
                        'assets/icons/pta.png', // Specify the path to your image asset
                    text: 'PTA Test',
                    onTap: () {
                      Navigator.pushNamed(context, '/ptaTest');
                    },
                  ),
                ),
                const Spacer(),

              ],
            ),
          ),



          Expanded(
            flex: 5,
            child: Row(
              children: [

                const Spacer(),
                SmallCard(
                  imagePath:
                      'assets/icons/books.png', // Specify the path to your image asset
                  text: 'Tutorials',
                  onTap: () {},
                ),
                const Spacer(),
                SmallCard(
                  imagePath:
                      'assets/icons/notepad.png', // Specify the path to your image asset
                  text: 'History',
                  onTap: () {},
                ),
                const Spacer(),
              ],
            ),
          ),
          const Spacer(flex: 5,)
        ],
      ),
    );
  }
}



