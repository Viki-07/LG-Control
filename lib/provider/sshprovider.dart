import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';

//provider class for state management
class SSHClientProvider extends ChangeNotifier {
  SSHClient? _sshClient;
  String _ip = '192.168.201.3';
  String _username = 'lg';
  String _password = '12';
  int _port = 22;
  int _rigs = 3;
 

  SSHClient? get sshClient => _sshClient;
  String get ip => _ip;
  String get username => _username;
  String get password => _password;
  int get port => _port;
  int get rigs => _rigs;


  set sshClient(SSHClient? value) {
    _sshClient = value;
    notifyListeners();
  }

  set ip(String value) {
    _ip = value;
    notifyListeners();
  }

  set username(String value) {
    _username = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set port(int value) {
    _port = value;
    notifyListeners();
  }

  set rigs(int value) {
    _rigs = value;
    notifyListeners();
  }


}
