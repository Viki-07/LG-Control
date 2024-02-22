
import 'package:flutter/material.dart';

import 'package:lgcontrol/kml/LookAt.dart';
import 'package:lgcontrol/kml/orbit.dart';
import 'package:lgcontrol/lg_functions.dart';
import 'package:lgcontrol/provider/sshprovider.dart';
import 'package:lgcontrol/screens/settings.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isOrbiting = false;
  //longitude and latitude of my homecity (Haridwar, Uttarakhand,India)
  double latvalue = 29.9457;
  double longvalue = 78.1642;
  //method to play orbit
  playOrbit() async {
    await LGFunctions(context: context)
        .buildOrbit(Orbit.buildOrbit(Orbit.generateOrbitTag(
            LookAt(longvalue, latvalue, "6341.7995674", "0", "0"))))
        .then((value) async {
      await LGFunctions(context: context).startOrbit();
    });
    setState(() {
      isOrbiting = true;
    });
  }

  //method to stop playing orbit
  stopOrbit() async {
    await LGFunctions(context: context).stopOrbit();
  }

  Future<void> rebootDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Do you really want to reboot VMs ?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                LGFunctions(context: context).rebootLG();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LG Control'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width:  800,
              child: Image.network('https://hips.hearstapps.com/hmg-prod/images/cute-photos-of-cats-looking-at-camera-1593184780.jpg?crop=0.6672958942897593xw:1xh;center,top&resize=980:*'),
            ),
            // SizedBox(
            //     height: 400,
            //     width: 800,
            //     child: Image.asset('assets/lglogo.png')),
            const SizedBox(
              height: 100,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                  onPressed: () {
                    rebootDialog(context);
                  },
                  child: const Text(
                    'Reboot LG',
                    style: TextStyle(fontSize: 24),
                  )),
              ElevatedButton(
                  onPressed: () {
                    LGFunctions(context: context).goToHomeTown();
                  },
                  child: const Text(
                    'Move to HomeCity',
                    style: TextStyle(fontSize: 24),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isOrbiting = !isOrbiting;
                    });
                    if (isOrbiting == true) {
                      await LGFunctions(context: context).cleanOrbit();
                      playOrbit();
                    } else {
                      stopOrbit();
                      await LGFunctions(context: context).cleanOrbit();
                    }
                  },
                  child: Row(
                    children: [
                      if (isOrbiting)
                        const Icon(Icons.stop)
                      else
                        const Icon(Icons.play_arrow),
                      const Text(
                        'Orbit  HomeCity',
                        style: TextStyle(fontSize: 24),
                      )
                    ],
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await LGFunctions(context: context).openLogos();
                  },
                  child: const Text(
                    'Print HTML Bubble',
                    style: TextStyle(fontSize: 24),
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
