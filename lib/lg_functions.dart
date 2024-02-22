import 'dart:io';
import 'package:lgcontrol/provider/sshprovider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dartssh2/dartssh2.dart';

class LGFunctions {
//getting path where local user data is stored in application
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

//method to  reboot all VM's
  Future<void> rebootLG(SSHClientProvider sshclientprovider) async {
    final pw = sshclientprovider.password;
    final client = SSHClient(
      await SSHSocket.connect(sshclientprovider.ip, sshclientprovider.port)
          .timeout(Duration(seconds: 5)),
      username: sshclientprovider.username,
      onPasswordRequest: () => sshclientprovider.password,
    );
    for (var i = sshclientprovider.rigs; i >= 1; i--) {
      try {
        await client
            .run('sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"');
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

//method to go to HomeCity(Haridwar, Uttarakhand ,India)
  goToHomeTown(SSHClientProvider sshclientprovider) async {
    try {
      await sshclientprovider.client!
          .execute('echo "search=Haridwar" >/tmp/query.txt');
    } catch (e) {
      print('An error occurred while executing the command: $e');
    }
  }

// method to build orbit file, upload and execute it on VMs
  buildOrbit(String content, SSHClientProvider sshclientprovider) async {
    String localPath = await _localPath;
    File localFile = File('$localPath/Orbit.kml');
    localFile.writeAsString(content);

    try {
      final sftp = await sshclientprovider.client!.sftp();
      final file = await sftp?.open('/var/www/html/Orbit.kml',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write);
      await file?.write(localFile.openRead().cast());
      await sshclientprovider.client!
          .execute("echo '\nhttp://lg1:81/Orbit.kml' > /var/www/html/kmls.txt");
      print('exec');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  //method to start playing orbit
  startOrbit(SSHClientProvider sshclientprovider) async {
    try {
      await sshclientprovider.client!
          .execute('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

// //method to stop orbitting
  stopOrbit(SSHClientProvider sshclientprovider) async {
    try {
      await sshclientprovider.client!
          .execute('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  cleanOrbit(SSHClientProvider sshclientprovider) async {
    try {
      await sshclientprovider.client!.run('echo "" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

// method to remove logo/image from screen
  Future cleanlogos(SSHClientProvider sshclientprovider) async {
    int rigs = sshclientprovider.rigs;
    String blank = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
  </Document>
</kml>''';
    rigs = (rigs / 2).floor() + 2;
    try {
      return await sshclientprovider.client!
          .execute("echo '$blank' > /var/www/html/kml/slave_${rigs - 1}.kml");
    } catch (e) {
      return Future.error(e);
    }
  }
  
   //method to upload image and display on rightmost screen

  Future openLogos(SSHClientProvider sshclientprovider) async {
    int rigs = sshclientprovider.rigs;
    String openLogoKML = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
	<name>LgControl</name>
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
      await sshclientprovider.client!.execute(
          "echo '$openLogoKML'  > /var/www/html/kml/slave_${rigs - 1}.kml");
    } catch (e) {
      return Future.error(e);
    }
  }
}
