import 'dart:io';

import 'package:emoji_manager/modules/bank/pic_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PicInfoScreen extends GetView<PicInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("表情详情"),
      ),
      body: listViewBody(),
    );
  }

  Widget listViewBody() {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(40, 40, 40, 20),
          child: Image(
            image: FileImage(
                File(controller.imagePath)
            ),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(60, 0, 60, 10),
          child: Row(
            children: [
              Expanded(
                child:  TextField(
                  controller: controller.nameController..text = controller.name.value,
                  autofocus: false,
                  decoration: InputDecoration(
                      helperText: '名称'
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(60, 0, 60, 30),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.keyWordController..text = controller.keyWord.value,
                  autofocus: false,
                  decoration: InputDecoration(
                    helperText: '关键字'
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 0, 30, 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    primary: Colors.amber,
                    onPrimary: Colors.white
                ),
                child: Text("确认修改",style: TextStyle(fontSize: 12),),
                onPressed: () async {
                  controller.picRename();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    primary: Colors.amber,
                    onPrimary: Colors.white
                ),
                child: Text("修改位置",style: TextStyle(fontSize: 12),),
                onPressed: () {
                  controller.fileReplace();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    primary: Colors.amber,
                    onPrimary: Colors.white
                ),
                child: Text("删除",style: TextStyle(fontSize: 12),),
                onPressed: () {
                  controller.picDelete();
                },
              )
            ],
          ),
        )
      ],
    );
  }

}