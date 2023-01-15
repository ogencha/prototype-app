import 'package:coriander/presentation/login/login_model.dart';
import 'package:coriander/presentation/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
            title: Text('ログイン'),
          ),
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'example@kboy.com'),
                  controller: mailController,
                  onChanged: (text) {
                    model.mail = text;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'パスワード'),
                    obscureText: true,
                  controller: passwordController,
                  onChanged: (text) {
                    model.password = text;
                  },
                ),
                ElevatedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      await model.signUp();
                       _showDialog(context, 'ログインしました');
                    } catch(e) {
                      _showDialog(context, e.toString());
                    }                   
                  },
                ),
                TextButton(
                  child: Text('新規登録する'),
                  onPressed: () async {
                    //画面遷移
                    await Navigator.push(
                 context,
                 MaterialPageRoute(
                 builder: (context) => SignUpPage(),
                 fullscreenDialog: true,
                  ),
                 );                
                  },
                ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future _showDialog(BuildContext context, String title) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}