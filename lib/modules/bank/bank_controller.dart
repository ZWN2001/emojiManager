
import 'dart:io';

import 'package:emoji_manager/widget/dialog/text_field_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:emoji_manager/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class BankController extends GetxController{

  final String dbName = 'emojiManager';
  final String tableName = 'directory_name';
  final String createDbSql = "CREATE TABLE directory_name (dirName TEXT PRIMARY KEY)";
  final String rootName = "emojiManager";
  final TextEditingController renameTc = new TextEditingController();
  final TextEditingController addTc = new TextEditingController();
  RxList<FileSystemEntity> files = <FileSystemEntity>[].obs;
  RxList<String> dirNameList = <String>[].obs;
  RxList picPathList = <FileSystemEntity>[].obs;
  Icon checkIcon = Icon(Icons.check_circle_outline,color: Colors.green);
  Icon uncheckIcon = Icon(Icons.radio_button_unchecked,color: Colors.white,);
  RxList<int> selectedIndexList = <int>[].obs;
  RxList<bool> hasFirstPicList = <bool>[].obs;
  List<String> firstPicPathList = [];
  var selectionMode = false.obs;
  var hasFirstPic = false.obs;
  Image tempImage = Image.network('https://www.itying.com/images/flutter/4.png');

  List<String> tempImageList = [
    'https://www.itying.com/images/flutter/1.png',
    'https://www.itying.com/images/flutter/2.png',
    'https://www.itying.com/images/flutter/3.png',
    'https://www.itying.com/images/flutter/4.png'
  ];

  ///添加图集操作
  void addPicAlbum() async {
    String albumName = addTc.text;
    hasFirstPicList.add(false);
    firstPicPathList.add("null");
    await DirectoryUtil().createDir(albumName);
    dirNameList.add(albumName);
    String sql = "INSERT INTO directory_name (dirName) VALUES (?)";
    await SqliteUtil().insert(dbName, sql, [albumName]).then((value) {
      getDirList1();
    });
    addTc.clear();
  }

  ///获取所有图集的路径
  Future getDirList(String dirName) async {
    String path = await DirectoryUtil().getDirPath(dirName);
    var directory = Directory(path);
    files.value = directory.listSync();
  }

  ///从数据库中获取所有图集名称
  Future getDirList1() async {
    if (dirNameList.length != 0) {
      dirNameList.clear();
    }
    String sql = 'SELECT * FROM directory_name';
    List<Map> list = await SqliteUtil().query(dbName, sql);
    print(list.length);
    if (list.length == 0) {
      print('no album');
      return;
    }
    list.forEach((element) {
      dirNameList.add(element['dirName']);
    });
  }

  Future getPicPathList() async {
    for (int i = 0; i < dirNameList.length; i++) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = '${documentsDirectory.path}${Platform.pathSeparator}'+'emojiManager'+'${Platform.pathSeparator}${dirNameList[i]}';
      var dir = Directory(path);
      picPathList.value = dir.listSync();
      if (picPathList.length == 0) {
        hasFirstPicList.add(false);
        firstPicPathList.add("null");
        print('此图集内没有图片');
      } else {
        hasFirstPicList.add(true);
        firstPicPathList.add(picPathList[0].path);
        print('此图集内有图片');
      }
    }
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
  void popMenuItemSelection(String str, BuildContext context) async {
    if (str == 'all_select') {
      for (int i = 0; i < dirNameList.length; i++) {
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
                  vc: renameTc,
                  okBtnTap: () async {
                    int i = selectedIndexList.elementAt(0);
                    print(renameTc.text);
                    print(dirNameList[i]);
                    String sql = "UPDATE directory_name SET dirName = ? WHERE dirName = ?";
                    String newName = renameTc.text;
                    await DirectoryUtil().dirRename(dirNameList[i], newName).then((value) {
                      print('success!');
                    });
                    await SqliteUtil().update(dbName, sql, [newName, dirNameList[i]]);
                    getDirList1().then((value) {
                      changeSelection(enable: false, index: -1);
                    });
                  },
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
        String sql = "DELETE FROM directory_name WHERE dirName = ?";
        await SqliteUtil().delete(dbName, sql, [dirNameList[j]]);
      }
      for (int i = 0; i < selectedIndexList.length; i++) {
        int j = selectedIndexList.elementAt(i);
        await DirectoryUtil().deleteDir(dirNameList[j]);
      }
      getDirList1().then((value) {
        getPicPathList();
        changeSelection(enable: false, index: -1);
      });
    }
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      dirNameList.clear();
      selectedIndexList.clear();
      selectionMode.value = false;
      SqliteUtil().createDb(createDbSql, dbName);
      DirectoryUtil().dirList(rootName).then((value) {
        getDirList1();
      });
    });
  }

  @override
  void onInit() {
    super.onInit();
    //DirectoryUtil().deleteDir("第一个/aaa?bbb.png.png");
    //File file = File("/data/user/0/com.example.emoji_manager/app_flutter/emojiManager/第一个/aaa?bbb.png.png");
    //file.delete();
    SqliteUtil().createDb(createDbSql, dbName);
    DirectoryUtil().dirList(rootName).then((value) {
      getDirList1().then((value) {
        getPicPathList();
      });
    });
  }

}

class BankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankController>(() => BankController());
  }
}
