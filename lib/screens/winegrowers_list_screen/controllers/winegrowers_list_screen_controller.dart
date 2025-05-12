import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/models/winegrower.dart';

class WinegrowersListScreenController extends GetxController {
  RxList<Winegrower> winegrowers = <Winegrower>[].obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseFirestore.instance.collection('winegrowers').snapshots().listen((snapshot) {
      final docs = snapshot.docs.map((doc) => Winegrower.fromDocument(doc)).toList();
      docs.sort((a, b) => a.name.compareTo(b.name));
      winegrowers.value = docs;
    });
  }
}
