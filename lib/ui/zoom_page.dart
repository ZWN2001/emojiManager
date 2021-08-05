
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:emoji_manager/util/image_edit_util/image_picker_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


class ZoomPage extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new ZoomPicPage();
  }
}

class ZoomPicPage extends StatefulWidget {
  @override
  _ZoomPicPageState createState() => _ZoomPicPageState();
}

class _ZoomPicPageState extends State<ZoomPicPage> {

  Image smallPic = Image.asset('assets/image.jpg',fit: BoxFit.scaleDown,width: 100,);
  Image bigPic =Image.asset('assets/image.jpg',fit: BoxFit.scaleDown,width: 200,);
  late Image pic,modifiedPic;
  TextEditingController _nameEditController = new TextEditingController();
  TextEditingController _keyWordEditController = new TextEditingController();

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    int? picWidth;
    GlobalKey smallKey = GlobalKey(),bigKey = GlobalKey();
    Uint8List? _memoryImage;

    return Scaffold(
      appBar: AppBar(
        title: Text("表情包放大"),
      ),
      body: Center(
          child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 600),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: PopupMenuButton<String>(
                                      child: AbsorbPointer(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                primary: Colors.black,
                                                backgroundColor: Colors.amber[50],
                                                side:BorderSide(color:Colors.amber) ,
                                                minimumSize: Size(width*0.3, height/14),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
                                              ),
                                              child: new Text("上传照片"),
                                              onPressed: (){},
                                            )
                                          ],
                                        ),
                                        absorbing: true,
                          ),
                                      itemBuilder: (BuildContext context) =>
                                      <PopupMenuItem<String>>[
                                        PopupMenuItem(
                                          child: Text("从相册选择照片"),
                                          value: "从相册选择照片",
                                        ),
                                        PopupMenuItem(
                                          child: Text("从表情包库选择照片"),
                                          value: "从表情包库选择照片",
                                        ),
                                      ],

                                      onSelected: (String result) async{
                                        if(result == "从相册选择照片"){
                                          _memoryImage = await pickImage(context);


                                          setState(() {
                                            /*pic = Image.memory(
                                              _memoryImage!,
                                              fit: BoxFit.scaleDown,
                                            );
                                            pic.image.resolve(new ImageConfiguration()).addListener(
                                                new ImageStreamListener((ImageInfo info, bool _) {
                                                  picWidth = info.image.width;
                                                  print(picWidth);
                                                }));
                                            modifiedPic = Image.memory(
                                              _memoryImage!,
                                              fit: BoxFit.scaleDown,
                                              width: picWidth!*2,
                                            );*/
                                            smallPic = Image.memory(
                                            _memoryImage!,
                                            fit: BoxFit.scaleDown,
                                          );
                                            smallPic.image.resolve(new ImageConfiguration()).addListener(
                                                new ImageStreamListener((ImageInfo info, bool _) {
                                                  picWidth = info.image.width;
                                                  print(picWidth);
                                                  smallPic = Image.memory(
                                                    _memoryImage!,
                                                    fit: BoxFit.scaleDown,
                                                    width: picWidth!/2,
                                                  );
                                                  bigPic = Image.memory(
                                                    _memoryImage!,
                                                    fit: BoxFit.scaleDown,
                                                    width: picWidth!*2,
                                                  );
                                                }));

                                          });
                                        }
                                  },
                                  ),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("before",
                                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      Text("after",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: SingleChildScrollView(
                                      physics: ClampingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: 3000),
                                        child: SingleChildScrollView(
                                          physics: ClampingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(maxHeight: 500),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                RepaintBoundary(
                                                    key: smallKey,
                                                    child: Container(
                                                      child: smallPic,)
                                                ),
                                                RepaintBoundary(
                                                    key: bigKey,
                                                    child: Container(
                                                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                      child: bigPic,)
                                                )

                                              ],
                                            ),
                                          ),
                                        )
                                      ),
                                    ))
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "名称:",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(child: TextField(
                                          controller: _nameEditController,
                                        )),
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "快捷命令:",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(child: TextField(
                                          controller: _keyWordEditController,
                                        )),
                                      ],
                                    ),
                                  ))
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FloatingActionButton.extended(
                                          label: new Text("  确定  "),
                                        onPressed: () async{
                                            saveImage(bigKey);
                                        },
                                          heroTag: 'second',
                                      ),
                                    ],
                                  )),
                            ],
                          ))
                    ],
                  ),
                ),
              ))),
    );
  }
  /// 保存图片
  static Future<void> saveImage(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final String? filePath =
    await ImageSaver.save('image.jpg', pngBytes);

    String msg = 'save image : $filePath';
    print(msg);

  }


}
