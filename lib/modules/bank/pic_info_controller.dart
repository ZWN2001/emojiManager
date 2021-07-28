import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PicInfoController extends GetxController {

  String imagePath = '';
  String name = "tempName"; //TODO: temp name
  String keyWord = "tempKeyWord"; //TODO: temp key word
  TextEditingController nameController = TextEditingController();
  TextEditingController keyWordController = TextEditingController();

  PicInfoController(String imagePath) {
    this.imagePath = imagePath;
  }

  @override
  void onInit() {
    super.onInit();
  }

}

class PicInfoBinding extends Bindings {

  String imagePath = '';
  PicInfoBinding(String imagePath) {
    this.imagePath = imagePath;
  }

  @override
  void dependencies() {
    Get.lazyPut<PicInfoController>(() => PicInfoController(imagePath));
  }

}