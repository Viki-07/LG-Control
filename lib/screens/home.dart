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
  //longitude and latitude of my homecity (Haridwar, Uttarakhand,India)
  bool isOrbiting = false;
  double latvalue = 29.9457;
  double longvalue = 78.1642;


  @override
  Widget build(BuildContext context) {
    return Consumer<SSHClientProvider>(
      builder: (context, sshclientprovider, child) => Scaffold(
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
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                if (sshclientprovider.client == null ||
                    sshclientprovider.isConnected == false)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Disconnected",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Connected",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  )
              ]),
              SizedBox(
                  height: 400,
                  width: 800,
                  child: Image.asset('assets/lglogo.png')),
              const SizedBox(
                height: 100,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                              'Do you really want to reboot VMs ?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  LGFunctions().rebootLG(sshclientprovider);
                                  sshclientprovider.client!.close();
                                  sshclientprovider.isConnected = false;
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Reboot LG',
                      style: TextStyle(fontSize: 24),
                    )),
                ElevatedButton(
                    onPressed: () {
                      LGFunctions().goToHomeTown(sshclientprovider);
                    },
                    child: const Text(
                      'Move to HomeCity',
                      style: TextStyle(fontSize: 24),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      if (isOrbiting == false) {
                        LGFunctions().cleanOrbit(sshclientprovider);
                        final lookat = LookAt(
                            longvalue, latvalue, "6341.7995674", "0", "0");
                        final orbitTag = Orbit.generateOrbitTag(lookat);
                        final buildOrbitContent = Orbit.buildOrbit(orbitTag);

                        LGFunctions()
                            .buildOrbit(buildOrbitContent, sshclientprovider)
                            .then((value) {
                          LGFunctions().startOrbit(sshclientprovider);
                          setState(() {
                            isOrbiting = true;
                          });
                        });
                      } else {
                        await LGFunctions().stopOrbit(sshclientprovider);
                        setState(() {
                          isOrbiting = false;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          isOrbiting == false ? 'Start Orbit' : 'Stop Orbit',
                          style: TextStyle(fontSize: 24),
                        )
                      ],
                    )),
                ElevatedButton(
                    onPressed: () async {
                      await LGFunctions().openLogos(sshclientprovider);
                    },
                    child: const Text(
                      'Print HTML Bubble',
                      style: TextStyle(fontSize: 24),
                    )),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
