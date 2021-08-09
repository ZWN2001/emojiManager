import 'dart:io';

import 'package:emoji_manager/modules/bank/bank_controller.dart';
import 'package:emoji_manager/util/directory_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaticEmojiInfoLogic extends GetxController {
  final BankController bankController = Get.find<BankController>();

  TextEditingController nameEditController = TextEditingController();
  TextEditingController keyWordEditController = TextEditingController();
  Rx<int> selectedValue = 0.obs;
  final String dirName = "emojiManager";
  late String selectedPath;
  List<DropdownMenuItem<int>> items=[];
  List<String> pathList=[];

  @override
  void onInit() {
    super.onInit();
    initMenuItem();
    getDirList(dirName).then((value) => selectedPath=pathList.first);
  }

  //初始化下拉菜单的items
  void initMenuItem() {
    for(int i = 0; i < bankController.dirNameList.length; i++){
        items.add(
            DropdownMenuItem(
                child: Text(bankController.dirNameList[i].toString()),
                value: i,
            ));
    }
    // bankController.dirNameList.forEach((element) {
    //   items.add(DropdownMenuItem(child: Text(element.toString())));
    // });
  }

  //重写bankController的获取路径的方法
  ///获取所有图集的路径
  Future getDirList(String dirName) async {
    String path = await DirectoryUtil().getDirPath(dirName);
    var directory = Directory(path);
     directory.listSync().forEach((element) {
       pathList.add(element.path);
    });
  }

}
class StaticEmojiInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaticEmojiInfoLogic>(() => StaticEmojiInfoLogic());
  }
}