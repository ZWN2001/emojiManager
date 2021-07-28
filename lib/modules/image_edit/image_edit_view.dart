import 'dart:typed_data';

import 'package:emoji_manager/util/image_edit_util/aspect_ratio.dart';
import 'package:emoji_manager/widget/flat_button_with_icon.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'image_edit_logic.dart';

class ImageEditPage extends StatelessWidget {
  final ImageEditLogic imageEditLogic = Get.put(ImageEditLogic());

  @override
  Widget build(BuildContext context) {
    String _name = imageEditLogic.emojiInfo['name'];
    String _keyWord=imageEditLogic.emojiInfo['keyWord'];
    Uint8List?  _memoryImage=imageEditLogic.emojiInfo['image'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('表情包编辑'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              imageEditLogic.cropImage();
            },
          ),
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30,),
            Text('    名称 :  $_name',style: TextStyle(fontSize: 20),),
            SizedBox(height: 5,),
            Text('    关键词 :  $_keyWord',style: TextStyle(fontSize: 20),),
            _imageWidget(_memoryImage)
          ]
      ),
      bottomNavigationBar: _bottomAppBar(context),
    );
  }

  Widget _imageWidget( Uint8List?  _memoryImage){
    return  Expanded(
        child:ExtendedImage.memory(
          _memoryImage!,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          enableLoadState: true,
          extendedImageEditorKey: imageEditLogic.editorKey,
          initEditorConfigHandler: (ExtendedImageState? state) {
            return EditorConfig(
              maxScale: 8.0,
              cropRectPadding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              hitTestSize: 20.0,
              cropLayerPainter: imageEditLogic.cropLayerPainter!,
              initCropRectType: InitCropRectType.imageRect,
              cropAspectRatio: imageEditLogic.cropAspectRatio.value.value,
            );
          },
          cacheRawData: true,
        )
    );
  }
  Widget _bottomAppBar(BuildContext context){
    return BottomAppBar(
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
                                imageEditLogic.cropAspectRatios.elementAt(index);
                                return GestureDetector(
                                child: AspectRatioWidget(
                                aspectRatio: item.value,
                                aspectRatioS: item.text,
                                isSelected: item == imageEditLogic.cropAspectRatio.value,
                                ),
                                onTap: () {
                                imageEditLogic.cropAspectRatio=item.obs;
                                Navigator.pop(context);
                                },
                                );
                              },
                              itemCount: imageEditLogic.cropAspectRatios.length,
                            ),
                          )
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
                imageEditLogic.editorKey.currentState!.flip();
              },
            ),
            FlatButtonWithIcon(
              icon: const Icon(Icons.rotate_left),
              label: const Text(
                '左旋转',
                style: TextStyle(fontSize: 10.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                imageEditLogic.editorKey.currentState!.rotate(right: false);
              },
            ),
            FlatButtonWithIcon(
              icon: const Icon(Icons.rotate_right),
              label: const Text(
                '右旋转',
                style: TextStyle(fontSize: 10.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                imageEditLogic.editorKey.currentState!.rotate(right: true);
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
                imageEditLogic.editorKey.currentState!.reset();
              },
            ),
          ],
        ),
      ),
    );
  }
}
