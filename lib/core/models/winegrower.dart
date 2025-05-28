import 'package:cloud_firestore/cloud_firestore.dart';

class Winegrower {
  final String id;
  final String domainName;
  final String winegrowerName;
  final String terroirName;
  final String description;
  final String imageURL;

  Winegrower({
    required this.id,
    required this.domainName,
    required this.winegrowerName,
    required this.terroirName,
    required this.description,
    required this.imageURL,
  });

  factory Winegrower.fromDocument(DocumentSnapshot doc) {
    return Winegrower(
      id: doc.id,
      domainName: doc['domainName'] ?? '',
      winegrowerName: doc['winegrowerName'] ?? '',
      terroirName: doc['terroirName'] ?? '',
      description: doc['description'] ?? '',
      imageURL: doc['imageURL'] ?? '',
    );
  }
}
