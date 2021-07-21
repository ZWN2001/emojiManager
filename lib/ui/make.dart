import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:emoji_manager/util/aspect_ratio.dart';
import 'package:emoji_manager/util/image_picker_io.dart';
import 'package:emoji_manager/util/crop_editor_helper.dart';
import 'package:emoji_manager/widget/flat_button_with_icon.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class ImageEditorDemo extends StatefulWidget {
  @override
  _ImageEditorDemoState createState() => _ImageEditorDemoState();
}

class _ImageEditorDemoState extends State<ImageEditorDemo> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
  GlobalKey<ExtendedImageEditorState>();
  final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
  GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
  final List<AspectRatioItem> _aspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: '自定义', value: CropAspectRatios.custom),
    AspectRatioItem(text: '原始比例', value: CropAspectRatios.original),
    AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
    AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
  ];
  AspectRatioItem? _aspectRatio;
  bool _cropping = false;

  EditorCropLayerPainter? _cropLayerPainter;

  @override
  void initState() {
    _aspectRatio = _aspectRatios.first;
    _cropLayerPainter = const EditorCropLayerPainter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('image editor'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: _getImage,
          ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
                _cropImage();
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: _memoryImage != null
              ? ExtendedImage.memory(
            _memoryImage!,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            enableLoadState: true,
            extendedImageEditorKey: editorKey,
            initEditorConfigHandler: (ExtendedImageState? state) {
              return EditorConfig(
                maxScale: 8.0,
                cropRectPadding: const EdgeInsets.all(20.0),
                hitTestSize: 20.0,
                cropLayerPainter: _cropLayerPainter!,
                initCropRectType: InitCropRectType.imageRect,
                cropAspectRatio: _aspectRatio!.value,
              );
            },
            cacheRawData: true,
          )
              : ExtendedImage.asset(
            'assets/image.jpg',
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            enableLoadState: true,
            extendedImageEditorKey: editorKey,
            initEditorConfigHandler: (ExtendedImageState? state) {
              return EditorConfig(
                maxScale: 8.0,
                cropRectPadding: const EdgeInsets.all(20.0),
                hitTestSize: 20.0,
                cropLayerPainter: _cropLayerPainter!,
                initCropRectType: InitCropRectType.imageRect,
                cropAspectRatio: _aspectRatio!.value,
              );
            },
            cacheRawData: true,
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        //color: Colors.lightBlue,
        shape: const CircularNotchedRectangle(),
        child: ButtonTheme(
          minWidth: 0.0,
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FlatButtonWithIcon(
                icon: const Icon(Icons.crop),
                label: const Text(
                  '裁剪',
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          children: <Widget>[
                            const Expanded(
                              child: SizedBox(),
                            ),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(20.0),
                                itemBuilder: (_, int index) {
                                  final AspectRatioItem item =
                                  _aspectRatios[index];
                                  return GestureDetector(
                                    child: AspectRatioWidget(
                                      aspectRatio: item.value,
                                      aspectRatioS: item.text,
                                      isSelected: item == _aspectRatio,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        _aspectRatio = item;
                                      });
                                    },
                                  );
                                },
                                itemCount: _aspectRatios.length,
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
              FlatButtonWithIcon(
                icon: const Icon(Icons.flip),
                label: const Text(
                  '镜像',
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState!.flip();
                },
              ),
              FlatButtonWithIcon(
                icon: const Icon(Icons.rotate_left),
                label: const Text(
                  '左旋转',
                  style: TextStyle(fontSize: 8.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState!.rotate(right: false);
                },
              ),
              FlatButtonWithIcon(
                icon: const Icon(Icons.rotate_right),
                label: const Text(
                  '右旋转',
                  style: TextStyle(fontSize: 8.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState!.rotate(right: true);
                },
              ),
              FlatButtonWithIcon(
                icon: const Icon(Icons.rounded_corner_sharp),
                label: PopupMenuButton<EditorCropLayerPainter>(
                  key: popupMenuKey,
                  enabled: false,
                  offset: const Offset(100, -300),
                  child: const Text(
                    'Painter',
                    style: TextStyle(fontSize: 8.0),
                  ),
                  initialValue: _cropLayerPainter,
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<EditorCropLayerPainter>>[
                      PopupMenuItem<EditorCropLayerPainter>(
                        child: Row(
                          children: const <Widget>[
                            Icon(
                              Icons.rounded_corner_sharp,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Default'),
                          ],
                        ),
                        value: const EditorCropLayerPainter(),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<EditorCropLayerPainter>(
                        child: Row(
                          children: const <Widget>[
                            Icon(
                              Icons.circle,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Custom'),
                          ],
                        ),
                        value: const CustomEditorCropLayerPainter(),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<EditorCropLayerPainter>(
                        child: Row(
                          children: const <Widget>[
                            Icon(
                              CupertinoIcons.circle,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Circle'),
                          ],
                        ),
                        value: const CircleEditorCropLayerPainter(),
                      ),
                    ];
                  },
                  onSelected: (EditorCropLayerPainter value) {
                    if (_cropLayerPainter != value) {
                      setState(() {
                        if (value is CircleEditorCropLayerPainter) {
                          _aspectRatio = _aspectRatios[2];
                        }
                        _cropLayerPainter = value;
                      });
                    }
                  },
                ),
                textColor: Colors.white,
                onPressed: () {
                  popupMenuKey.currentState!.showButtonMenu();
                },
              ),
              FlatButtonWithIcon(
                icon: const Icon(Icons.restore),
                label: const Text(
                  '重置',
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState!.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    if (_cropping) {
      return;
    }
    String msg = '';
    try {
      _cropping = true;
      Uint8List? fileData;
        fileData = await cropImageDataWithNativeLibrary(state: editorKey.currentState!);

      final String? filePath =
      await ImageSaver.save('extended_image_cropped_image.jpg', fileData!);

      msg = 'save image : $filePath';
    } catch (e, stack) {
      msg = 'save failed: $e\n $stack';
      print(msg);
    }
    _cropping = false;
  }

  Uint8List? _memoryImage;
  Future<void> _getImage() async {
    _memoryImage = await pickImage(context);
    //when back to current page, may be editorKey.currentState is not ready.
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        editorKey.currentState!.reset();
      });
    });
  }
}

class CustomEditorCropLayerPainter extends EditorCropLayerPainter {
  const CustomEditorCropLayerPainter();
  @override
  void paintCorners(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Paint paint = Paint()
      ..color = painter.cornerColor
      ..style = PaintingStyle.fill;
    final Rect cropRect = painter.cropRect;
    const double radius = 6;
    canvas.drawCircle(Offset(cropRect.left, cropRect.top), radius, paint);
    canvas.drawCircle(Offset(cropRect.right, cropRect.top), radius, paint);
    canvas.drawCircle(Offset(cropRect.left, cropRect.bottom), radius, paint);
    canvas.drawCircle(Offset(cropRect.right, cropRect.bottom), radius, paint);
  }
}

class CircleEditorCropLayerPainter extends EditorCropLayerPainter {
  const CircleEditorCropLayerPainter();

  @override
  void paintCorners(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    // do nothing
  }

  @override
  void paintMask(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect rect = Offset.zero & size;
    final Rect cropRect = painter.cropRect;
    final Color maskColor = painter.maskColor;
    canvas.saveLayer(rect, Paint());
    canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.fill
          ..color = maskColor);
    canvas.drawCircle(cropRect.center, cropRect.width / 2.0,
        Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  void paintLines(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect cropRect = painter.cropRect;
    if (painter.pointerDown) {
      canvas.save();
      canvas.clipPath(Path()..addOval(cropRect));
      super.paintLines(canvas, size, painter);
      canvas.restore();
    }
  }
}
