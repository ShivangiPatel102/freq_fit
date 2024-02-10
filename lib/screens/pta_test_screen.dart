import 'package:flutter/material.dart';
import 'package:freq_fit/widgets/my_drawer.dart';
import 'package:freq_fit/widgets/app_bar.dart';
import 'package:freq_fit/widgets/card.dart';

class PtaTestScreen extends StatelessWidget {
  const PtaTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarCustom(title: 'PTA TEST'),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(right: 25.0,left: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 4,),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Patient Name',
                  hintStyle: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.w400,color: Color.fromRGBO(40, 51, 74, 1),),

                  ),
                ),
            ),

            const Spacer(),

            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Patient Email',
                  hintStyle: TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.w400,color: Color.fromRGBO(40, 51, 74, 1),),

                ),
              ),
            ),

            const Spacer(flex: 2,),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/pureTone') ;
                },
                child: Container(
                  height: 38,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(40, 51, 74, 1),
                  child: const Center(child: Text('Register',style: TextStyle(fontFamily: 'Blinker',fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700))),
                ),
              ),
            ),

            const Spacer(flex: 3,),

            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallCard(imagePath: 'assets/icons/puretone.png', text: 'Pure Tone', onTap: (){}),
                  //SmallCard(imagePath: 'assets/icons/boneConduct.png', text: 'Bone Conduct', onTap: (){}),
                ],
              ),
            ),

            const Spacer(flex: 4,),

          ],
        ),
      ),
    );
  }
}



