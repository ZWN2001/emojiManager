import 'dart:typed_data';

import 'package:emoji_manager/modules/image_draw/image_draw_view.dart';
import 'package:emoji_manager/util/image_edit_util/aspect_ratio.dart';
import 'package:emoji_manager/util/image_edit_util/crop_editor_helper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageEditLogic extends GetxController {
  final GlobalKey<ExtendedImageEditorState> editorKey =
  GlobalKey<ExtendedImageEditorState>();
  final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
  GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
  final List<AspectRatioItem> cropAspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: '自定义', value: CropAspectRatios.custom),
    AspectRatioItem(text: '原始比例', value: CropAspectRatios.original),
    AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
    AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
  ];
  late Rx<AspectRatioItem> cropAspectRatio;
  bool cropping = false;
  Map emojiInfo = Get.arguments;
  EditorCropLayerPainter? cropLayerPainter;

  @override
  void onInit() {
    super.onInit();
    cropAspectRatio = cropAspectRatios.elementAt(0).obs ;
    cropLayerPainter = const EditorCropLayerPainter();
  }

  Future<void> cropImage() async {
    if (cropping) {
      return;
    }
    String msg = '';
    try {
      cropping = true;
      Uint8List? fileData;
      fileData = await cropImageDataWithNativeLibrary(state: editorKey.currentState!);
      emojiInfo['image']=fileData;
      Get.toNamed('/ImageDrawPage',arguments: emojiInfo);
    } catch (e, stack) {
      msg = 'save failed: $e\n $stack';
      print(msg);
    }
    cropping = false;
  }
}
class ImageEditBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageEditLogic>(() => ImageEditLogic());
  }
}
