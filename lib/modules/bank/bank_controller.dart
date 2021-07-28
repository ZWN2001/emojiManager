
import 'dart:io';

import 'package:emoji_manager/widget/dialog/text_field_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:emoji_manager/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class BankController extends GetxController{

  final String rootName = "emojiManager";
  final TextEditingController tc = new TextEditingController();
  RxList<FileSystemEntity> files = <FileSystemEntity>[].obs;
  Icon checkIcon = Icon(Icons.check_circle_outline,color: Colors.green);
  Icon uncheckIcon = Icon(Icons.radio_button_unchecked,color: Colors.white,);
  RxList<int> selectedIndexList = <int>[].obs;
  var selectionMode = false.obs;

  List<String> tempImageList = [
    'https://www.itying.com/images/flutter/1.png',
    'https://www.itying.com/images/flutter/2.png',
    'https://www.itying.com/images/flutter/3.png',
    'https://www.itying.com/images/flutter/4.png'
  ];

  ///添加图集操作
  void addPicAlbum() async {
    String albumName = tc.text;
    await DirectoryUtil().createDir(albumName);
    DirectoryUtil().dirList(rootName);
    getDirList(rootName);
    tc.clear();
  }

  ///获取所有图集的路径
  Future getDirList(String dirName) async {
    String path = await DirectoryUtil().getDirPath(dirName);
    var directory = Directory(path);
    files.value = directory.listSync();
  }

  ///改变长按选择项，enable是true为选中状态，false为未选中状态
  void changeSelection({required bool enable, required int index}) {
    selectionMode.value = enable;
    selectedIndexList.add(index);
    if (index == -1) {
      selectedIndexList.clear();
    }
  }

  ///选择顶部菜单栏响应
  void popMenuItemSelection(String str, BuildContext context) {
    if (str == 'all_select') {
      for (int i = 0; i < files.length; i++) {
        if (!selectedIndexList.contains(i)) {
          selectedIndexList.add(i);
        }
      }
    } else if (str == 'rename') {
      showDialog(
          context: context,
          builder: (context) {
            return TextFieldDialog(
                contentWidget: TextFieldDialogContent(
                  title: "请输入图集的新名字",
                  okBtnTap: () async {
                    int i = selectedIndexList.elementAt(0);
                    await DirectoryUtil().dirRename(
                      files.elementAt(i).path.substring(files.elementAt(i).parent.path.length+1),
                      tc.text
                    ).then((value) {
                      getDirList(rootName).then((value) {
                        changeSelection(enable: false, index: -1);
                      });
                    });
                  },
                  vc: tc,
                  cancelBtnTap: () {
                    print('click cancel');
                  },
               )
            );
          }
      );
    } else if (str == 'delete') {
      for (int i = 0; i < selectedIndexList.length; i++) {
        int j = selectedIndexList.elementAt(i);
        DirectoryUtil().deleteDir(
            files.elementAt(j).path.substring(files.elementAt(j).parent.path.length+1)).then((value) {
           getDirList(rootName).then((value) {
             changeSelection(enable: false, index: -1);
           });
        });
      }
    }
  }

  Future onRefresh() async {

  }

  @override
  void onInit() {
    super.onInit();
    DirectoryUtil().dirList(rootName).then((value) {
      getDirList(rootName);
    });
  }

}

class BankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankController>(() => BankController());
  }
}
