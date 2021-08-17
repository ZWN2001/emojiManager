import 'dart:typed_data';

import 'package:emoji_manager/modules/zoom_page/zoom_page_logic.dart';
import 'package:emoji_manager/util/image_edit_util/image_picker_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ZoomPage extends StatelessWidget {
  final ZoomPageLogic zoomPageLogic = Get.put(ZoomPageLogic());

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
                                      zoomPageLogic.memoryImage = await pickImage(context);
                                      zoomPageLogic.update();
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
                                                        child: zoomPageLogic.smallPic,)
                                                  ),
                                                  RepaintBoundary(
                                                      key: bigKey,
                                                      child: Container(
                                                        margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                        child: zoomPageLogic.bigPic,)
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
                                          controller: zoomPageLogic.nameEditController,
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
                                          controller: zoomPageLogic.keyWordEditController,
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
                                          zoomPageLogic.info={
                                            'name':zoomPageLogic.nameEditController.text,
                                            'keyWord':zoomPageLogic.keyWordEditController.text,
                                            'image':zoomPageLogic.memoryImage,
                                            'path':zoomPageLogic.selectedPath,
                                          };
                                          zoomPageLogic.saveImage(bigKey);
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

}