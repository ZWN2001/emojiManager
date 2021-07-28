import 'dart:io';
import 'dart:ui';

import 'package:emoji_manager/modules/bank/pic_album_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

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

  Future getPicPathList(String dirName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}${Platform.pathSeparator}'+'emojiManager'+'${Platform.pathSeparator}$dirName';
    var dir = Directory(path);
    picPathList.value = dir.listSync();
  }

  Future getImageList() async {
    picPathList.forEach((element) {
      imageList.add(Image(image: FileImage(File(element.toString())),fit: BoxFit.cover,));
    });
    print('finished');
  }

  @override
  void onInit() {
    super.onInit();
    print('dirName');
    print(dirName);
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