import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coriander/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddBookModel extends ChangeNotifier{
  String bookTitle = '';
  File? imageFile;

  final picker = ImagePicker();

  Future addBookToFirebase() async {
    if (bookTitle.isEmpty) {
      throw('タイトルを入力してください');
    }

    FirebaseFirestore.instance.collection('books').add(
      {
        'title': bookTitle,
        'createdAt': Timestamp.now(),
      },
    );
  }

  Future updateBook(Book book) async {
    final document = FirebaseFirestore.instance.collection('books').doc(book.documentID);
    await document.update(
      {
        'title': bookTitle,
        'updateAt': Timestamp.now(),
      },
    );
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
    imageFile = File(pickedFile.path);
    }
  }
}