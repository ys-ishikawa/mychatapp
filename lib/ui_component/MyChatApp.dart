import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:loading/loading.dart';
import 'package:mychatapp/ui_component/LoginPage.dart';
import 'package:provider/provider.dart';


// 更新可能なデータ
class UserState extends ChangeNotifier {
  User user;

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}

class MyChatApp extends StatefulWidget {
  @override
  _MyChatAppState createState() => _MyChatAppState();
}

class _MyChatAppState extends State<MyChatApp> {
  bool _initialized = false;
  bool _error = false;

  final UserState userState = UserState();

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // return Loading();
    }
    if (_error) {}
    
    // ユーザ情報を渡す 
    return ChangeNotifierProvider<UserState>.value(
      value: userState,      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyChatApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
      ),
    );
    
  }
}
