import 'package:flutter/material.dart';
import 'package:lgcontrol/provider/sshprovider.dart';
import 'package:lgcontrol/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SSHClientProvider())
      ],
      child: MaterialApp(
        title: 'LGControl',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
