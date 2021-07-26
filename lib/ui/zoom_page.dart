import 'dart:typed_data';

import 'package:emoji_manager/util/image_edit_util/image_picker_io.dart';
import 'package:flutter/material.dart';

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

  Image smallPic = Image.network(
    'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20180514%2F05%2F1526248503-ORhUjucmZk.jpg&refer=http%3A%2F%2Fimage.biaobaiju.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1629800422&t=cea70e269918cee0244dcc76ef20454b',
    fit: BoxFit.scaleDown,
    width: 100,
  );
  Image bigPic = Image.network(
    'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20180514%2F05%2F1526248503-ORhUjucmZk.jpg&refer=http%3A%2F%2Fimage.biaobaiju.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1629800422&t=cea70e269918cee0244dcc76ef20454b',
    fit: BoxFit.scaleDown,
    width: 200,
  );
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

                                          setState(() {smallPic = Image.memory(
                                            _memoryImage!,
                                            fit: BoxFit.scaleDown,
                                            width: 100,
                                          );
                                          bigPic = Image.memory(
                                            _memoryImage!,
                                            fit: BoxFit.scaleDown,
                                            width: 200,
                                          );
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
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("before"),
                                      Text("after"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                       smallPic,
                                        bigPic,
                                      ],
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
                                        onPressed: () {


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
