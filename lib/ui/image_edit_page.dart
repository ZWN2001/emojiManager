// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:emoji_manager/ui/image_draw_page.dart';
// import 'package:emoji_manager/util/image_edit_util/aspect_ratio.dart';
// import 'package:emoji_manager/util/image_edit_util/crop_editor_helper.dart';
// import 'package:emoji_manager/widget/flat_button_with_icon.dart';
// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class ImageEditPage extends StatefulWidget {
//   @override
//   _ImageEditPageState createState() => _ImageEditPageState();
// }
//
// class _ImageEditPageState extends State<ImageEditPage> {
//   final GlobalKey<ExtendedImageEditorState> editorKey =
//   GlobalKey<ExtendedImageEditorState>();
//   final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
//   GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
//   final List<AspectRatioItem> _cropAspectRatios = <AspectRatioItem>[
//     AspectRatioItem(text: '自定义', value: CropAspectRatios.custom),
//     AspectRatioItem(text: '原始比例', value: CropAspectRatios.original),
//     AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
//     AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
//     AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
//     AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
//     AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
//   ];
//   AspectRatioItem? _cropAspectRatio;
//   bool _cropping = false;
//   Map _emojiInfo = Get.arguments;
//
//   EditorCropLayerPainter? _cropLayerPainter;
//
//   @override
//   void initState() {
//     _cropAspectRatio = _cropAspectRatios.first;
//     _cropLayerPainter = const EditorCropLayerPainter();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String _name = _emojiInfo['name'];
//     String _keyWord=_emojiInfo['keyWord'];
//     Uint8List?  _memoryImage=_emojiInfo['image'];
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('表情包编辑'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.done),
//             onPressed: () {
//               _cropImage();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//                 SizedBox(height: 30,),
//                 Text('    名称 :  $_name',style: TextStyle(fontSize: 20),),
//                 SizedBox(height: 5,),
//                 Text('    关键词 :  $_keyWord',style: TextStyle(fontSize: 20),),
//
//             _imageWidget(_memoryImage)
//           ]
//       ),
//       bottomNavigationBar: _bottomAppBar(),
//     );
//   }
//
//   Widget _imageWidget( Uint8List?  _memoryImage){
//     return  Expanded(
//       child: ExtendedImage.memory(
//         _memoryImage!,
//         fit: BoxFit.contain,
//         mode: ExtendedImageMode.editor,
//         enableLoadState: true,
//         extendedImageEditorKey: editorKey,
//         initEditorConfigHandler: (ExtendedImageState? state) {
//           return EditorConfig(
//             maxScale: 8.0,
//             cropRectPadding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
//             hitTestSize: 20.0,
//             cropLayerPainter: _cropLayerPainter!,
//             initCropRectType: InitCropRectType.imageRect,
//             cropAspectRatio: _cropAspectRatio!.value,
//           );
//         },
//         cacheRawData: true,
//       )
//     );
//   }
//   Widget _bottomAppBar(){
//     return BottomAppBar(
//       //color: Colors.lightBlue,
//       shape: const CircularNotchedRectangle(),
//       child: ButtonTheme(
//         minWidth: 0.0,
//         padding: EdgeInsets.zero,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             FlatButtonWithIcon(
//               icon: const Icon(Icons.crop),
//               label: const Text(
//                 '裁剪',
//                 style: TextStyle(fontSize: 10.0),
//               ),
//               textColor: Colors.white,
//               onPressed: () {
//                 showDialog<void>(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return Column(
//                         children: <Widget>[
//                           const Expanded(
//                             child: SizedBox(),
//                           ),
//                           SizedBox(
//                             height: 100,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               scrollDirection: Axis.horizontal,
//                               padding: const EdgeInsets.all(20.0),
//                               itemBuilder: (_, int index) {
//                                 final AspectRatioItem item =
//                                 _cropAspectRatios[index];
//                                 return GestureDetector(
//                                   child: AspectRatioWidget(
//                                     aspectRatio: item.value,
//                                     aspectRatioS: item.text,
//                                     isSelected: item == _cropAspectRatio,
//                                   ),
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                     setState(() {
//                                       _cropAspectRatio = item;
//                                     });
//                                   },
//                                 );
//                               },
//                               itemCount: _cropAspectRatios.length,
//                             ),
//                           ),
//                         ],
//                       );
//                     });
//               },
//             ),
//             FlatButtonWithIcon(
//               icon: const Icon(Icons.flip),
//               label: const Text(
//                 '镜像',
//                 style: TextStyle(fontSize: 10.0),
//               ),
//               textColor: Colors.white,
//               onPressed: () {
//                 editorKey.currentState!.flip();
//               },
//             ),
//             FlatButtonWithIcon(
//               icon: const Icon(Icons.rotate_left),
//               label: const Text(
//                 '左旋转',
//                 style: TextStyle(fontSize: 10.0),
//               ),
//               textColor: Colors.white,
//               onPressed: () {
//                 editorKey.currentState!.rotate(right: false);
//               },
//             ),
//             FlatButtonWithIcon(
//               icon: const Icon(Icons.rotate_right),
//               label: const Text(
//                 '右旋转',
//                 style: TextStyle(fontSize: 10.0),
//               ),
//               textColor: Colors.white,
//               onPressed: () {
//                 editorKey.currentState!.rotate(right: true);
//               },
//             ),
//             FlatButtonWithIcon(
//               icon: const Icon(Icons.restore),
//               label: const Text(
//                 '重置',
//                 style: TextStyle(fontSize: 10.0),
//               ),
//               textColor: Colors.white,
//               onPressed: () {
//                 editorKey.currentState!.reset();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _cropImage() async {
//     if (_cropping) {
//       return;
//     }
//     String msg = '';
//     try {
//       _cropping = true;
//       Uint8List? fileData;
//       fileData = await cropImageDataWithNativeLibrary(state: editorKey.currentState!);
//
//       _emojiInfo['image']=fileData;
//       Get.to(()=>DrawlPage(),arguments: _emojiInfo);
//       // final String? filePath =
//       // await ImageSaver.save('extended_image_cropped_image.jpg', fileData!);
//       //
//       // msg = 'save image : $filePath';
//     } catch (e, stack) {
//       msg = 'save failed: $e\n $stack';
//       print(msg);
//     }
//     _cropping = false;
//   }
// }
//
