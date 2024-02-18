import 'package:flutter/material.dart';
import 'package:lgcontrol/lg_functions.dart';
import 'package:lgcontrol/provider/sshprovider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController ipController = TextEditingController(text: '');
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController portController = TextEditingController(text: '');
  TextEditingController rigsController = TextEditingController(text: '');

//initializing all the text editing controllers used in settings screen.
  initTextControllers(BuildContext context) {
    ipController.text =
        Provider.of<SSHClientProvider>(context, listen: false).ip;
    usernameController.text =
        Provider.of<SSHClientProvider>(context, listen: false).username;
    passwordController.text =
        Provider.of<SSHClientProvider>(context, listen: false).password;
    portController.text =
        Provider.of<SSHClientProvider>(context, listen: false).port.toString();
    rigsController.text =
        Provider.of<SSHClientProvider>(context, listen: false).rigs.toString();
  }

//updating all the text editing controllers when they are changed
  updateProviders(BuildContext context) {
    Provider.of<SSHClientProvider>(context, listen: false).ip =
        ipController.text;
    Provider.of<SSHClientProvider>(context, listen: false).username =
        usernameController.text;
    Provider.of<SSHClientProvider>(context, listen: false).password =
        passwordController.text;
    Provider.of<SSHClientProvider>(context, listen: false).port =
        int.parse(portController.text);
    Provider.of<SSHClientProvider>(context, listen: false).rigs =
        int.parse(rigsController.text);
  }

  @override
  void initState() {
    super.initState();
    initTextControllers(context);
  }

  Widget customInput(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }

  @override
  void dispose() {
    ipController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    portController.dispose();
    rigsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                customInput(ipController, "IP Address"),
                customInput(usernameController, "Username"),
                customInput(passwordController, "Password"),
                customInput(portController, "Port"),
                customInput(rigsController, "Rigs"),
                ElevatedButton(
                  onPressed: () {
                    updateProviders(context);
                  },
                  child: const Text('Save Preferences'),
                ),
                ElevatedButton(
                  onPressed: () {
                    LGFunctions(context: context).cleanlogos();
                  },
                  child: const Text('Clean Logos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
