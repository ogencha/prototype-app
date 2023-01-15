import 'package:coriander/domain/book.dart';
import 'package:coriander/presentation/add_book/add_book_page.dart';
import 'package:coriander/presentation/book_list/book_list_model.dart';
import 'package:coriander/presentation/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>.value(
      value: BookListModel()..fetchBooks(),
      child: Scaffold(
        appBar: AppBar(
            title: const Text('本一覧'),
            actions: [
              IconButton(
                onPressed: () async {
                //画面遷移
                await Navigator.push(
                 context,
                 MaterialPageRoute(
                 builder: (context) => LoginPage(),
                 fullscreenDialog: true,
                  ),
                 );
              }, 
              icon: Icon(Icons.person),
              ),
            ],
          ),
        body: Consumer<BookListModel>(
          builder: (context, model, child) {
            final books = model.books;
            final listTiles = books
            .map(
              (book) => Slidable(

                  endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      flex: 2,
                      backgroundColor: Colors.black45,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: '編集',
                      onPressed: (context) async {
                        //編集画面に遷移
                        final bool? added = await Navigator.push(
                         context,
                         MaterialPageRoute(
                         builder: (context) => AddBookPage(
                          book: book,
                          ),
                          ),
                         );                    
                       }
                      ),
                    SlidableAction(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: '削除',
                      onPressed: ((context) async {
                        //todo:削除
                        await showDialog(
                         context: context,
                         builder: (BuildContext context) {
                         return AlertDialog(
                           title: Text('『${book.title}』を削除しますか？'),
                           actions: <Widget>[
                             TextButton(
                               child: const Text('OK'),
                               onPressed: () async {
                                 Navigator.of(context).pop();

                                 // todo: 削除のAPIをたたく
                                 await deleteBook(context, model, book);
                                 },
                               ),
                             ],
                           );
                         },
                       );
                      }),
                    ),
                  ],
                ),

                child: ListTile(
                  leading: book.imageURL != null ? Image.network(book.imageURL) : null,
                  title: Text(book.title),
                  ),
                )
              )
              .toList();
            return ListView(
              children: listTiles,
              );
          },
        ),
        floatingActionButton: 
        Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
              // todo
               await Navigator.push(
                 context,
                 MaterialPageRoute(
                 builder: (context) => AddBookPage(),
                 fullscreenDialog: true,
                  ),
                 );
                 model.fetchBooks();
             },
            );
          }
        ),
        ),
      );
  }

  Future deleteBook(
    BuildContext context, 
    BookListModel model, 
    Book book
    ) async {
     try {
    await model.deleteBook(book);
    await model.fetchBooks();
    } catch(e) {
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