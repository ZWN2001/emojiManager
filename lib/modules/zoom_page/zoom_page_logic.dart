import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:emoji_manager/util/image_edit_util/image_picker_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ZoomPageLogic extends GetxController{
  TextEditingController nameEditController = new TextEditingController();
  TextEditingController keyWordEditController = new TextEditingController();
  final String dirName = "emojiManager";
  late String selectedPath;
  late Image smallPic;
  late Image bigPic;
  late Map info;
  late Uint8List? memoryImage;
  int? picWidth;

  @override
  void onInit() {
    super.onInit();
    smallPic = Image.asset('assets/image.jpg',fit: BoxFit.scaleDown,width: 100,);
    bigPic =Image.asset('assets/image.jpg',fit: BoxFit.scaleDown,width: 200,);
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    smallPic = Image.memory(
      memoryImage!,
      fit: BoxFit.scaleDown,
    );
    smallPic.image.resolve(new ImageConfiguration()).addListener(
        new ImageStreamListener((ImageInfo info, bool _) {
          picWidth = info.image.width;
          print(picWidth);
          smallPic = Image.memory(
            memoryImage!,
            fit: BoxFit.scaleDown,
            width: picWidth!/2,
          );
          bigPic = Image.memory(
            memoryImage!,
            fit: BoxFit.scaleDown,
            width: picWidth!*2,
          );
        }));
  }

  Future<void> saveImage(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    await ImageSaver.saveImg('${info['name']}?${info['keyWord']}.png', pngBytes,info['path']);
  }

}

class ZoomPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ZoomPageLogic>(() => ZoomPageLogic());
  }
}