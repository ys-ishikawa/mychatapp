import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychatapp/ui_component/AddPostPage.dart';
import 'package:mychatapp/ui_component/LoginPage.dart';
import 'package:mychatapp/ui_component/MyChatApp.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("チャット"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }),
                );
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Text('ログイン情報: ${user.email}'),
          ),
          Expanded(
            // FutureBuilder(非同期処理の結果を元にWidgetを作成)
            // → StreamBuilder
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                // データ取得ができた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data.docs;
                  // 取得したメッセージ一覧をリスト表示
                  return ListView(
                    children: documents.map((document) {
                      IconButton deleteIcon;
                      if (document['email'] == user.email) {
                        deleteIcon = IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(document.id)
                                .delete();
                          },
                        );
                      }
                      return Card(
                        child: ListTile(
                          title: Text(document['text']),
                          subtitle: Text(document['email']),
                          trailing: deleteIcon,
                        ),
                      );
                    }).toList(),
                  );
                }
                return Center(
                  child: Text('読込中...'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return AddPostPage();
          }));
        },
      ),
    );
  }
}
