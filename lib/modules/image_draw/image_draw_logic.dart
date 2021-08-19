import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:emoji_manager/util/util.dart';
import 'package:emoji_manager/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ImageDrawLogic extends GetxController {

  static final List<Color> colors = [
    Colors.black,
    Colors.redAccent,
    Colors.lightBlueAccent,
    Colors.greenAccent,
  ];
  Color selectedColor = colors[0];

   RxList<Widget> stackChildren=<Widget>[].obs;
   //添加文字框的列表
   List<ImageTextField> textList=<ImageTextField>[];

  static final List<double> lineWidths = [5.0, 8.0, 10.0];
  RxList<Point> points = [Point(colors[0], lineWidths[0],  [])].obs;

  Map emojiInfo = Get.arguments;
  late Uint8List imageFile;
  late Image emojiImage;

  int selectedLine = 0;
  int curFrame = 0;
  double get strokeWidth => lineWidths[selectedLine];
  late double picWidth;
  late double picHeight;

  final GlobalKey repaintKey = new GlobalKey();

  // late Stack drawStack;
  Rx<bool> isDraw=true.obs;
  bool isClear = false;

  @override
  void onInit()  {
    super.onInit();
    imageFile=emojiInfo['image'];
    emojiImage=Image.memory(imageFile);
    stackChildren.add(emojiImage);
    // drawStack=new Stack(children: stackChildren.value,);
  }

  void addTextField(TapUpDetails details){
    ImageTextField textField=new ImageTextField(
      details.localPosition.dx,
      details.localPosition.dy,
      selectedColor,
      picWidth,
      picHeight,
    );
    // textList.add(textField);
    // if(textList.length>1){
    //   for(int i=0;i<textList.length-1;i++){
    //     if(!textList[i].isEmptyInput()){
    //       stackChildren.add(textList[i]);
    //     }
    //   }
    // }else{
      stackChildren.add(textField);
    // }

    // textList.forEach((element) {
    //   if(!element.isEmptyInput()){
    //     stackChildren.add(element);
    //   }
    // });
    update();
  }

  Future saveEmoji(RenderRepaintBoundary boundary) async {
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    await ImageSaver.saveImg('${emojiInfo['name']}?${emojiInfo['keyWord']}', pngBytes,emojiInfo['path']);
    print(emojiInfo['path']);
  }

  void reset() {
    isClear = true;
    curFrame = 0;
    points.clear();
    points.add(Point(selectedColor, strokeWidth,  []));
    update();
  }
}
class ImageDrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImageDrawLogic());
  }
}