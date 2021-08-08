import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageTextFieldLogic extends GetxController {
Rx<bool> focus=true.obs;
}

class ImageTextFieldBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImageTextFieldLogic());
  }
}