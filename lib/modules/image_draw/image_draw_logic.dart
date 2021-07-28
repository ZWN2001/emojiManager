import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:emoji_manager/util/image_edit_util/image_picker_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:emoji_manager/util/image_draw_painter.dart';
class ImageDrawLogic extends GetxController {
  static final List<Color> colors = [
    Colors.redAccent,
    Colors.lightBlueAccent,
    Colors.greenAccent,
  ];
  static final List<double> lineWidths = [5.0, 8.0, 10.0];
  Map emojiInfo = Get.arguments;
  late Uint8List imageFile;
  late Image emojiImage;
  int selectedLine = 0;
  Color selectedColor = colors[0];
  List<Point> points = [Point(colors[0], lineWidths[0], [])];
  int curFrame = 0;
  bool isClear = false;
  final GlobalKey repaintKey = new GlobalKey();
  double get strokeWidth => lineWidths[selectedLine];


  Future saveEmoji(RenderRepaintBoundary boundary) async {
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final String? filePath =
    await ImageSaver.save('${emojiInfo['name']}?${emojiInfo['keyWord']}.png', pngBytes);
    //TODO 向数据库存数据
    String msg = 'save image : $filePath';
    print(msg);
  }

  void reset() {
    isClear = true;
    curFrame = 0;
    points.clear();
    points.add(Point(selectedColor, strokeWidth, []));
  }
}
class ImageDrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImageDrawLogic());
  }
}