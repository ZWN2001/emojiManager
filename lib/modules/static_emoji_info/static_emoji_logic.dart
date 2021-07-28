import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StaticEmojiInfoLogic extends GetxController {
  TextEditingController nameEditController = new TextEditingController();
  TextEditingController keyWordEditController = new TextEditingController();


}
class StaticEmojiInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaticEmojiInfoLogic>(() => StaticEmojiInfoLogic());
  }
}