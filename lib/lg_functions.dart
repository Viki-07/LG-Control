import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lgcontrol/provider/sshprovider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ssh2/ssh2.dart';

class LGFunctions {
  final BuildContext context;

  LGFunctions({required this.context});

//getting path where local user data is stored in application
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

//getter for getting data from SSHCLientProvider Class (Provider Class)
  SSHClientProvider get sshclientprovider {
    final sshclient = Provider.of<SSHClientProvider>(context, listen: false);
    return sshclient;
  }

//method to create snackbar in case of any error or exception
  void showSnackBar(
      {required String message, int duration = 3, Color color = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 14, color: color),
        ),
        backgroundColor: Colors.black.withOpacity(0.9),
        duration: Duration(seconds: duration),
      ),
    );
  }

//method to  reboot all VM's

  Future<void> rebootLG() async {
    final pw = sshclientprovider.password;
    SSHClient client = SSHClient(
      host: sshclientprovider.ip,
      port: sshclientprovider.port,
      username: sshclientprovider.username,
      passwordOrKey: sshclientprovider.password,
    );
    for (var i = 5; i >= 1; i--) {
      try {
        await client.connect();
        await client
            .execute('sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"');
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

//method to go to HomeCity(Haridwar, Uttarakhand ,India)
  goToHomeTown() async {
    SSHClient client = SSHClient(
      host: sshclientprovider.ip,
      port: sshclientprovider.port,
      username: sshclientprovider.username,
      passwordOrKey: sshclientprovider.password,
    );

    try {
      await client.connect();
      await client.execute('echo "search=Haridwar" >/tmp/query.txt');
    } catch (e) {
      print('An error occurred while executing the command: $e');
    }
  }

//method to build orbit file, upload and execute it on VMs
  buildOrbit(String content) async {
    String localPath = await _localPath;
    File localFile = File('$localPath/Orbit.kml');
    localFile.writeAsString(content);

    String filePath = '$localPath/Orbit.kml';

    SSHClient client = SSHClient(
      host: sshclientprovider.ip,
      port: sshclientprovider.port,
      username: sshclientprovider.username,
      passwordOrKey: sshclientprovider.password,
    );

    try {
      await client.connect();
      await client.connectSFTP();
      await client.sftpUpload(
        path: filePath,
        toPath: '/var/www/html',
        callback: (progress) {
          print('Sent $progress');
        },
      );
      await client.execute(
          "echo '\nhttp://lg1:81/Orbit.kml' >> /var/www/html/kmls.txt");
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  //method to start playing orbit
  startOrbit() async {
    SSHClient client = SSHClient(
      host: sshclientprovider.ip,
      port: sshclientprovider.port,
      username: sshclientprovider.username,
      passwordOrKey: sshclientprovider.password,
    );

    try {
      await client.connect();
      await client.execute('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

//method to stop orbitting
  stopOrbit() async {
    SSHClient client = SSHClient(
      host: sshclientprovider.ip,
      port: sshclientprovider.port,
      username: sshclientprovider.username,
      passwordOrKey: sshclientprovider.password,
    );

    try {
      await client.connect();
      await client.execute('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  cleanOrbit() async {
    SSHClient client = SSHClient(
      host: sshclientprovider.ip,
      port: sshclientprovider.port,
      username: sshclientprovider.username,
      passwordOrKey: sshclientprovider.password,
    );

    try {
      await client.connect();
      await client.execute('echo "" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

// method to remove logo/image from screen
  Future cleanlogos() async {
    SSHClient client = SSHClient(
      host: sshclientprovider.ip,
      port: sshclientprovider.port,
      username: sshclientprovider.username,
      passwordOrKey: sshclientprovider.password,
    );
    int rigs = sshclientprovider.rigs;
    String blank = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
  </Document>
</kml>''';
    rigs = (rigs / 2).floor() + 2;
    try {
      await client.connect();
      return await client
          .execute("echo '$blank' > /var/www/html/kml/slave_${1}.kml");
    } catch (e) {
      return Future.error(e);
    }
  } //method to upload image and display on rightmost screen

  Future openLogos() async {
    SSHClient client = SSHClient(
      host: sshclientprovider.ip,
      port: sshclientprovider.port,
      username: sshclientprovider.username,
      passwordOrKey: sshclientprovider.password,
    );

    int rigs = sshclientprovider.rigs;
    String openLogoKML = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
	<name>VolTrac</name>
	<open>3</open>
	<Folder>
		<name>tags</name>
		<Style>
			<ListStyle>
				<listItemType>checkHideChildren</listItemType>
				<bgColor>00ffffff</bgColor>
				<maxSnippetLines>2</maxSnippetLines>
			</ListStyle>
		</Style>
		<ScreenOverlay id="abc">
			<name>VolTrac</name>
			<Icon>
        <href>https://raw.githubusercontent.com/Viki-07/logo/main/WINWORD_15lEyUdabQ.png</href>
			</Icon>
        <overlayXY x="0.3" y="0.3" xunits="fraction" yunits="fraction"/>
        <screenXY x="0.2" y="0.3" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="0" y="0" xunits="pixels" yunits="fraction"/>
		</ScreenOverlay>
	</Folder>
</Document>
</kml>
  ''';
    try {
      await client.connect();
      await client.execute(
          "echo '$openLogoKML'  > /var/www/html/kml/slave_${rigs - 1}.kml");
    } catch (e) {
      return Future.error(e);
    }
  }
}
