
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:emoji_manager/util/util.dart';
import 'package:flutter/cupertino.dart';

class BankController extends GetxController{

  final String rootName = 'emojiManager';
  final TextEditingController tc = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var files = <FileSystemEntity>[].obs;

  void addPicAlbum() async {
    await DirectoryUtil().createDir(tc.text);
    DirectoryUtil().dirList(rootName);
    _getDirList(rootName);
    tc.clear();
  }

  Future _getDirList(String dirName) async {
    files.value = Directory(await DirectoryUtil().getDirPath(dirName)).listSync();
  }

  Future onRefresh() async {

  }

  @override
  void onInit() {
    super.onInit();
    DirectoryUtil().dirList(rootName).then((value) {
      _getDirList(rootName);
    });
  }

}

class BankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankController>(() => BankController());
  }
}
