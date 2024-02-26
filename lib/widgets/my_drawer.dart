import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freq_fit/constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: const EdgeInsets.all(10.0),
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                const Text('FreqFit',
                    style: TextStyle(
                        fontFamily: 'Blinker',
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: kNavyBlueColor)),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset('assets/icons/home.png', height: 20.0),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Image.asset('assets/icons/checklist.png', height: 19.0),
            title: const Text('Trial Test'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Image.asset('assets/icons/pta.png', height: 20.0),
            title: const Text('PTA Test'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ptaTest');
            },
          ),
          ListTile(
            leading: Image.asset('assets/icons/books.png', height: 20.0),
            title: const Text('Tutorials'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/notepad.png',
              height: 20.0,
            ),
            title: const Text('History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/profile.png',
              height: 20.0,
            ),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}

