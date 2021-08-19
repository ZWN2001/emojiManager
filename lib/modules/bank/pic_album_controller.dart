import 'dart:io';

import 'package:emoji_manager/util/directory_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PicAlbumController extends GetxController {

  String dirName = '';
  RxList picPathList = <FileSystemEntity>[].obs;
  RxList imageList = <Image>[].obs;

  PicAlbumController(String dirName) {
    this.dirName = dirName;
  }

  RxList tempImageList = <String>[
    'https://www.itying.com/images/flutter/1.png',
    'https://www.itying.com/images/flutter/2.png',
    'https://www.itying.com/images/flutter/3.png',
    'https://www.itying.com/images/flutter/4.png'
  ].obs;

  ///获取图集内所有图片路径
  Future getPicPathList(String dirName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}${Platform.pathSeparator}'+'emojiManager'+'${Platform.pathSeparator}$dirName';
    var dir = Directory(path);
    picPathList.value = dir.listSync();
    print('length');
    print(picPathList.length);
  }

  /*Future getImageList() async {
    picPathList.forEach((element) {
      imageList.add(Image(image: FileImage(File(element.toString())),fit: BoxFit.cover,));
    });
    print('finished');
  }*/

  ///根据路径获取图集内所有图片
  Future getImageList() async {
    picPathList.forEach((element) async {
      if (await Permission.storage.request().isGranted) {
        imageList.add(Image(image: FileImage(File(element.path)),fit: BoxFit.cover,));
      } else {
        imageList.add(Image.network( 'https://www.itying.com/images/flutter/4.png',fit: BoxFit.cover));
      }
    });
  }

  Future initAgain() async {
    picPathList.clear();
    imageList.clear();
    DirectoryUtil().dirList(dirName);
    getPicPathList(dirName).then((value) {
      getImageList();
    });
  }

  @override
  void onInit() {
    super.onInit();
    print('dirName');
    print(dirName);
    DirectoryUtil().dirList(dirName);
    getPicPathList(dirName).then((value) {
      getImageList();
    });
  }

}

class PicAlbumBinding extends Bindings {

  String dirName = '';

  PicAlbumBinding(String dirName) {
    this.dirName = dirName;
  }

  @override
  void dependencies() {
    Get.lazyPut<PicAlbumController>(() => PicAlbumController(dirName));
  }

}