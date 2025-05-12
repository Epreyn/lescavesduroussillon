import 'package:cloud_firestore/cloud_firestore.dart';

class Winegrower {
  final String id;
  final String name;
  final String imageURL;

  Winegrower({required this.id, required this.name, required this.imageURL});

  factory Winegrower.fromDocument(DocumentSnapshot doc) {
    return Winegrower(
      id: doc.id,
      name: doc['name'] ?? '',
      imageURL: doc['imageURL'] ?? '',
    );
  }
}
