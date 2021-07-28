import 'package:emoji_manager/util/image_draw_painter.dart';
import 'package:emoji_manager/util/image_edit_util/asperct_raio_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'image_draw_logic.dart';


class ImageDrawPage extends StatelessWidget {
  final imageDrawLogic = Get.put(ImageDrawLogic());

  @override
  Widget build(BuildContext context) {
    imageDrawLogic.imageFile=imageDrawLogic.emojiInfo['image'];
    imageDrawLogic.emojiImage=Image.memory(imageDrawLogic.imageFile);
    return Scaffold(
      appBar: AppBar(title:Text('表情包涂鸦')),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: SizedBox()),
            RepaintBoundary(
              key: imageDrawLogic.repaintKey,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  imageDrawLogic.emojiImage,
                  Positioned(
                    child: _buildCanvas(),
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildCanvas() {
    return StatefulBuilder(builder: (context, state) {
      return AsperctRaioImage.memory(
          imageDrawLogic.imageFile,
          memoryBuilder:  (context, snapshot, url){
            return CustomPaint(
              size: Size(snapshot.data!.width.toDouble(),snapshot.data!.height.toDouble()),
              foregroundPainter: ScrawlPainter(
                points: imageDrawLogic.points,
                strokeColor: imageDrawLogic.selectedColor,
                strokeWidth: imageDrawLogic.strokeWidth,
                isClear: imageDrawLogic.isClear,
              ),
              child: GestureDetector(
                // child: _emojiImage,
                onPanStart: (details) {
                  imageDrawLogic.isClear = false;
                  imageDrawLogic.points[imageDrawLogic.curFrame].color
                  = imageDrawLogic.selectedColor;
                  imageDrawLogic.points[imageDrawLogic.curFrame].strokeWidth
                  = imageDrawLogic.strokeWidth;
                },
                onPanUpdate: (details) {
                  RenderBox referenceBox = context.findRenderObject() as RenderBox;
                  Offset localPosition =
                  referenceBox.globalToLocal(details.globalPosition);
                  state(() {
                    imageDrawLogic.points[imageDrawLogic.curFrame].points.add(localPosition);
                  });
                },
                onPanEnd: (details) {
                  // preparing for next line painting.
                  imageDrawLogic.points.add(
                      Point(imageDrawLogic.selectedColor, imageDrawLogic.strokeWidth, [])
                  );
                  imageDrawLogic.curFrame++;
                },
              ) ,
            );
          }
      );

    });
  }

  Widget _buildBottom() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: StatefulBuilder(builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.brightness_1,
                size: 10.0,
                color: imageDrawLogic.selectedLine == 0
                    ? Colors.black87
                    : Colors.grey.withOpacity(0.5),
              ),
              onTap: () {
                state(() {
                  imageDrawLogic.selectedLine = 0;
                });
              },
            ),
            GestureDetector(
              child: Icon(
                Icons.brightness_1,
                size: 15.0,
                color: imageDrawLogic.selectedLine == 1
                    ? Colors.black87
                    : Colors.grey.withOpacity(0.5),
              ),
              onTap: () {
                state(() {
                  imageDrawLogic.selectedLine = 1;
                });
              },
            ),
            GestureDetector(
              child: Icon(
                Icons.brightness_1,
                size: 20.0,
                color: imageDrawLogic.selectedLine == 2
                    ? Colors.black87
                    : Colors.grey.withOpacity(0.5),
              ),
              onTap: () {
                state(() {
                  imageDrawLogic.selectedLine = 2;
                });
              },
            ),
            GestureDetector(
              child: Container(
                color: imageDrawLogic.selectedColor == ImageDrawLogic.colors[0]
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.transparent,
                child: Icon(
                  Icons.create,
                  color: ImageDrawLogic.colors[0],
                ),
              ),
              onTap: () {
                state(() {
                  imageDrawLogic.selectedColor = ImageDrawLogic.colors[0];
                });
              },
            ),
            GestureDetector(
              child: Container(
                color: imageDrawLogic.selectedColor == ImageDrawLogic.colors[1]
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.transparent,
                child: Icon(
                  Icons.create,
                  color: ImageDrawLogic.colors[1],
                ),
              ),
              onTap: () {
                state(() {
                  imageDrawLogic.selectedColor = ImageDrawLogic.colors[1];
                });
              },
            ),
            GestureDetector(
              child: Container(
                color: imageDrawLogic.selectedColor == ImageDrawLogic.colors[2]
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.transparent,
                child: Icon(
                  Icons.create,
                  color: ImageDrawLogic.colors[2],
                ),
              ),
              onTap: () {
                state(() {
                  imageDrawLogic.selectedColor = ImageDrawLogic.colors[2];
                });
              },
            ),
            GestureDetector(
              child: Text('清除痕迹'),
              onTap: () {
                imageDrawLogic.reset();
              },
            ),
            GestureDetector(
              child: Text('保存'),
              onTap: ()  async{
                RenderRepaintBoundary boundary =
                imageDrawLogic.repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                imageDrawLogic.saveEmoji(boundary);
              },
            ),
          ],
        );
      }),
    );
  }
}
