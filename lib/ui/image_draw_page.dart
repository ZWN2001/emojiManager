import 'dart:async';
import 'dart:typed_data';
import 'package:emoji_manager/util/image_edit_util/image_picker_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:emoji_manager/util/image_draw_painter.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class DrawlPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawlState();
}

class _DrawlState extends State<DrawlPage> {
  static final List<Color> colors = [
    Colors.redAccent,
    Colors.lightBlueAccent,
    Colors.greenAccent,
  ];
  static final List<double> lineWidths = [5.0, 8.0, 10.0];
  late Uint8List _imageFile=Get.arguments as Uint8List;
  late Image _emojiImage=Image.memory(_imageFile);
  int selectedLine = 0;
  Color selectedColor = colors[0];
  List<Point> points = [Point(colors[0], lineWidths[0], [])];
  int curFrame = 0;
  bool isClear = false;
  final GlobalKey _repaintKey = new GlobalKey();

  double get strokeWidth => lineWidths[selectedLine];

  @override
  void initState()  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text('表情包涂鸦')),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                // child: Container(
                //   color: Colors.white,
                  // margin: EdgeInsets.all(0.0),
                  child: RepaintBoundary(
                    key: _repaintKey,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        _emojiImage,
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
                // ),
              ),
              _buildBottom(),
            ],
          ),
        ),
      );
  }

  Widget _buildCanvas() {
    return StatefulBuilder(builder: (context, state) {
      return CustomPaint(
        foregroundPainter: ScrawlPainter(
          points: points,
          strokeColor: selectedColor,
          strokeWidth: strokeWidth,
          isClear: isClear,
        ),
        child: GestureDetector(
          child: _emojiImage,
            onPanStart: (details) {
              isClear = false;
              points[curFrame].color = selectedColor;
              points[curFrame].strokeWidth = strokeWidth;
            },
            onPanUpdate: (details) {
              RenderBox referenceBox = context.findRenderObject() as RenderBox;
              Offset localPosition =
              referenceBox.globalToLocal(details.globalPosition);
              state(() {
                points[curFrame].points.add(localPosition);
              });
            },
            onPanEnd: (details) {
              // preparing for next line painting.
              points.add(Point(selectedColor, strokeWidth, []));
              curFrame++;
            },
          ) ,
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
                color: selectedLine == 0
                    ? Colors.black87
                    : Colors.grey.withOpacity(0.5),
              ),
              onTap: () {
                state(() {
                  selectedLine = 0;
                });
              },
            ),
            GestureDetector(
              child: Icon(
                Icons.brightness_1,
                size: 15.0,
                color: selectedLine == 1
                    ? Colors.black87
                    : Colors.grey.withOpacity(0.5),
              ),
              onTap: () {
                state(() {
                  selectedLine = 1;
                });
              },
            ),
            GestureDetector(
              child: Icon(
                Icons.brightness_1,
                size: 20.0,
                color: selectedLine == 2
                    ? Colors.black87
                    : Colors.grey.withOpacity(0.5),
              ),
              onTap: () {
                state(() {
                  selectedLine = 2;
                });
              },
            ),
            GestureDetector(
              child: Container(
                color: selectedColor == colors[0]
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.transparent,
                child: Icon(
                  Icons.create,
                  color: colors[0],
                ),
              ),
              onTap: () {
                state(() {
                  selectedColor = colors[0];
                });
              },
            ),
            GestureDetector(
              child: Container(
                color: selectedColor == colors[1]
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.transparent,
                child: Icon(
                  Icons.create,
                  color: colors[1],
                ),
              ),
              onTap: () {
                state(() {
                  selectedColor = colors[1];
                });
              },
            ),
            GestureDetector(
              child: Container(
                color: selectedColor == colors[2]
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.transparent,
                child: Icon(
                  Icons.create,
                  color: colors[2],
                ),
              ),
              onTap: () {
                state(() {
                  selectedColor = colors[2];
                });
              },
            ),
            GestureDetector(
              child: Text('清除痕迹'),
              onTap: () {
                setState(() {
                  reset();
                });
              },
            ),
            GestureDetector(
              child: Text('保存'),
              onTap: ()  async{
                RenderRepaintBoundary boundary =
                _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                _saveEmoji(boundary);
                },
            ),
          ],
        );
      }),
    );
  }

  Future _saveEmoji(RenderRepaintBoundary boundary) async {
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final String? filePath =
      await ImageSaver.save('image.jpg', pngBytes);

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
