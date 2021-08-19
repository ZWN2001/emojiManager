import 'package:emoji_manager/util/directory_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'bank_controller.dart';

class PicInfoController extends GetxController {

  String imagePath = '';
  String dirName = '';
  RxString name = "tempName".obs;
  RxString keyWord = "tempKeyWord".obs;
  RxInt selectedValue = 0.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController keyWordController = TextEditingController();
  final BankController bankController = Get.find<BankController>();
  List<DropdownMenuItem<int>> items=[];

  PicInfoController(String imagePath, String dirName) {
    this.imagePath = imagePath;
    this.dirName = dirName;
  }

  getNameAndKey(String imagePath) {
    List temp = imagePath.split("/");
    String string = temp[temp.length - 1];
    print(string);
    List nameAndKey = string.split("?");
    name.value = nameAndKey[0];
    List keyList = nameAndKey[1].toString().split(".");
    keyWord.value = keyList[0];
    print(name);
    print(keyWord);
  }

  Future picRename() async {
    name.value = nameController.text;
    keyWord.value = keyWordController.text;
    await DirectoryUtil().fileRename(
        imagePath,
        "${nameController.text}?${keyWordController.text}.png"
    ).then((value) {
      Fluttertoast.showToast(
        msg: "修改成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16
      );
      Get.back(result: "refresh");
    });
  }

  Future picDelete() async {
    Get.defaultDialog(
      title: "提示",
      content: Text("确定要删除吗？"),
      textConfirm: "确认",
      textCancel: "取消",
      onConfirm: () async {
        await DirectoryUtil().fileDelete(imagePath).then((value) {
          Fluttertoast.showToast(
              msg: "删除成功",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              fontSize: 16
          );
          Get.back();
          Get.back(result: "refresh");
        });
      }
    );
  }

  Future fileReplace() async {
    Get.defaultDialog(
      title: "请选择图集",
      content: DropdownButton(
        value: selectedValue.value,
        icon: Icon(Icons.arrow_drop_down, size: 24,),
        isExpanded: true,
        underline: Container(height: 1, color: Colors.grey),
        items: items,
        onChanged: (value) {
          selectedValue.value = int.parse(value.toString());
        },
      ),
      textConfirm: "确认",
      textCancel: "取消",
      onConfirm: () async {
        DirectoryUtil().fileReplace(
            imagePath,
            bankController.dirNameList[selectedValue.value].toString()
        );
        Get.back();
        Get.back(result: "refresh");
      }
    );
  }


  void initDropItem() {
    print('length');
    print(bankController.dirNameList.length);
    for(int i = 0; i < bankController.dirNameList.length; i++){
      items.add(
          DropdownMenuItem(
            child: Text(bankController.dirNameList[i].toString()),
            value: i,
          ));
    }
  }

  @override
  void onInit() {
    super.onInit();
    print(imagePath);
    getNameAndKey(imagePath);
    initDropItem();
  }

}

class PicInfoBinding extends Bindings {

  String imagePath = '';
  String dirName = '';
  PicInfoBinding(String imagePath, String dirName) {
    this.imagePath = imagePath;
    this.dirName = dirName;
  }

  @override
  void dependencies() {
    Get.lazyPut<PicInfoController>(() => PicInfoController(imagePath, dirName));
  }

}