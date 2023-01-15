import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  Book(QueryDocumentSnapshot doc) {
    documentID = doc.id;
    title = doc['title'];
    imageURL = doc['imageURL'];
  }

  late String documentID;
  late String title;
  late String imageURL;
}