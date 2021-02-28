import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychatapp/ui_component/ChatPage.dart';
import 'package:mychatapp/ui_component/MyChatApp.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorText = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      body: Center(
          child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'メールアドレス'),
              onChanged: (String value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
              onChanged: (String value) {
                setState(() {
                  password = value;
                });
              },
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Text(errorText),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('ユーザ登録'),
                onPressed: () async {
                  // ユーザ登録に成功した場合
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    final User user = result.user;
                    userState.setUser(user);
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return ChatPage();
                      }),
                    );
                  } catch (e) {
                    // ユーザ登録に失敗した場合
                    setState(() {
                      errorText = "登録に失敗しました:${e.message}";
                    });
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              child: OutlineButton(
                textColor: Colors.blue,
                child: Text('ログイン'),
                onPressed: () async {
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    final User user = result.user;
                    userState.setUser(user);
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return ChatPage();
                      }),
                    );
                  } catch (e) {
                    setState(() {
                      errorText = "ログインに失敗しました:${e.message}";
                    });
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
