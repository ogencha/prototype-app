import 'package:coriander/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_book_model.dart';

class AddBookPage extends StatelessWidget {
  AddBookPage({this.book});
  final Book? book;
  @override
  Widget build(BuildContext context) {
    final bool isUpdate = book != null;
    final textEditingController = TextEditingController();

    if (isUpdate) {
      textEditingController.text = book!.title;
    }

    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdate ? '本を編集' : '本を追加'),
        ),
        body: Consumer<AddBookModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      width: 100,
                      height: 160,
                      child: model.imageFile != null
                            ? Image.file(model.imageFile!)
                            : Container(
                                color: Colors.grey,
                      ),
                    ),
                    onTap: () async {
                      await model.pickImage();
                    },
                  ),
                  TextField(
                    controller: textEditingController,
                    onChanged: (text) {
                      model.bookTitle = text;
                    },
                  ),
                  ElevatedButton(
                    child: Text(isUpdate ? '更新する' : '追加する'),
                    onPressed: () async {
                      if (isUpdate) {
                        await updateBook(model, context);
                      } else {
                        //firestoreに本を追加
                        await addBook(model, context);
                      }
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

  Future addBook(AddBookModel model, BuildContext context) async {
    try {
      await model.addBookToFirebase();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('保存しました'),
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
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

  Future updateBook(AddBookModel model, BuildContext context) async {
    try {
      await model.updateBook(book!);
      await _showDialog(context, '更新しました！');
    } catch (e) {
      await _showDialog(context, e.toString());
    }
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
