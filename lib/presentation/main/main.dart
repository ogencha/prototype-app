import 'package:coriander/presentation/book_list/book_list_page.dart';
import 'package:coriander/presentation/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ChangeNotifierProvider<MainModel>(
        create: (_) => MainModel(),
        child: Scaffold(
        appBar: AppBar(
          title: const Text('コリアンダー'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
            return Center(
              child: Column(
                children: [
                  Text(
                        model.kboyText,
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      ElevatedButton(
                        child: Text('本一覧'),
                        onPressed: (() {
                        //ここで何か
                       Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => BookListPage()
                        ),
                       );
                      }), 
                      ),
                ],
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}