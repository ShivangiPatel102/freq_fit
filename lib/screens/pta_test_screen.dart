import 'package:flutter/material.dart';
import 'package:freq_fit/constants.dart';
import 'package:freq_fit/widgets/my_drawer.dart';
import 'package:freq_fit/widgets/app_bar.dart';
import 'package:freq_fit/widgets/card.dart';

class PtaTestScreen extends StatelessWidget {
  const PtaTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarCustom(title: 'PTA TEST'),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(right: 25.0, left: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 3,
            ),
            Expanded(
              flex: 3,
              child: Card(
                elevation: 0,
                margin: EdgeInsets.symmetric(horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: kVeryLightGreyColor,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: 'Enter Patient Name',
                              hintStyle: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(40, 51, 74, 1),
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 3,
              child: Card(
                elevation: 0,
                margin: EdgeInsets.symmetric(horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: kVeryLightGreyColor,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: 'Enter Patient Email',
                              hintStyle: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(40, 51, 74, 1),
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Expanded(flex: 2, child: MyAnimatedButton()),
            const Spacer(
              flex: 3,
            ),
            Expanded(
              flex: 7,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 6,
                    child: SmallCard(
                        imagePath: 'assets/icons/puretone.png',
                        text: 'Pure Tone',
                        onTap: () {
                          Navigator.pushNamed(context, '/pureTone');
                        }),
                  ),
                  const Spacer(),
                  Expanded(
                      flex: 6,
                      child: Stack(
                        children: [
                          SmallCard(
                              imagePath: 'assets/icons/boneConduct.png',
                              text: 'Bone Conduct',
                              onTap: () {}),
                          Positioned.fill(child: Card(
                            color: kWhiteWidgetColor.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center
                              ,
                              children: [Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                            
                                children: [
                                  Expanded(child: Text('Coming     Soon!!',textAlign: TextAlign.center,style: TextStyle(color: kNavyBlueColor,fontWeight: FontWeight.w500))),
                                ],
                              )],
                            ),
                          ),
                        ),],
                      ),),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(
              flex: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.color,
  });
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      height: 20,
      color: color,
      child: Center(
        child: color == Colors.green
            ? Icon(
                Icons.check,
                color: Colors.white,
              )
            : Text(
                'Register',
                style: TextStyle(
                    fontFamily: 'Blinker',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}

class MyAnimatedButton extends StatefulWidget {
  @override
  _MyAnimatedButtonState createState() => _MyAnimatedButtonState();
}

class _MyAnimatedButtonState extends State<MyAnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _animationController =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);

    // Initialize Color Animation
    _colorAnimation = ColorTween(begin: kNavyBlueColor, end: Colors.green)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Start the animation when tapped
        // _animationController.forward();

        // Add a 2-second delay using Future.delayed
        Future.delayed(Duration(milliseconds: 1500), () {
          _animationController.forward();
          // Code to be executed after the delay
          // For example, you can show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration Successful!'),
            ),
          );
        });
      },
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return RegisterButton(color: _colorAnimation.value);
        },
      ),
    );
  }
}
