import 'package:get/get.dart';

class DynamicHorizontalSnapListController extends GetxController {
  final focusedIndex = 0.obs;

  void onItemFocus(int index) {
    focusedIndex.value = index;
  }
}
