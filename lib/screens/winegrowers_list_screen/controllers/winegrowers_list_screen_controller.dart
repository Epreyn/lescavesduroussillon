import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/models/winegrower.dart';

class WinegrowersListScreenController extends GetxController {
  final RxList<Winegrower> winegrowers = <Winegrower>[].obs;

  final RxBool isGrid = true.obs;
  void toggleView(bool v) => isGrid.value = v;

  @override
  void onInit() {
    super.onInit();
    FirebaseFirestore.instance.collection('winegrowers').snapshots().listen((
      s,
    ) {
      final docs =
          s.docs.map((d) => Winegrower.fromDocument(d)).toList()
            ..sort((a, b) => a.domainName.compareTo(b.domainName));
      winegrowers.value = docs;
    });
  }
}
