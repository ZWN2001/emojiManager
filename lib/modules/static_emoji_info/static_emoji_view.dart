import 'dart:typed_data';

import 'package:emoji_manager/modules/static_emoji_info/static_emoji_logic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


class StaticEmojiInfoPage extends StatelessWidget {
  final StaticEmojiInfoLogic staticEmojiInfoLogic = Get.put(StaticEmojiInfoLogic());
  // final BankController bankController = Get.find<BankController>();

  @override
  Widget build(BuildContext context) {
    Uint8List? _memoryImage = Get.arguments;
    return Scaffold(
        appBar: AppBar(
          title: const Text('制作静态表情包'),
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(40, 25, 40, 20),
              child: Image.memory(
                _memoryImage!,
                fit: BoxFit.contain,
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(80, 0, 80, 10),
              child: _buildDropDown(),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(80, 0, 80, 10),
              child: TextField(
                autofocus: false,
                controller: staticEmojiInfoLogic.nameEditController,
                decoration: InputDecoration(
                  labelText: "名称",
                  helperText: "给表情包起个名字吧",
                  isDense:true,
                  contentPadding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(80, 0, 80, 30),
              child: TextField(
                autofocus: false,
                controller: staticEmojiInfoLogic.keyWordEditController,
                decoration: InputDecoration(
                  labelText: "关键字",
                  helperText: "设置关键字，以便在输入时快捷访问",
                  isDense:true,
                  contentPadding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(120, 0, 120, 40),
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                    primary: Colors.amber,
                    onPrimary: Colors.white
                ),
                child: Text('下一步',style: TextStyle(fontSize: 24),),
                onPressed: (){
                  if(staticEmojiInfoLogic.nameEditController.text==''||staticEmojiInfoLogic.nameEditController.text.isEmpty){
                    Fluttertoast.showToast(msg: '名称不能为空',toastLength: Toast.LENGTH_SHORT);
                  }else{
                    Map emojiInfo={
                      'name':staticEmojiInfoLogic.nameEditController.text,
                      'keyWord':staticEmojiInfoLogic.keyWordEditController.text,
                      'image':_memoryImage,
                      'path':staticEmojiInfoLogic.selectedPath,
                    };
                    Get.toNamed("/ImageEditPage",arguments: emojiInfo);
                  }
                },
              ),
            ),
          ],
        ));
  }
  Widget _buildDropDown(){
    return GetBuilder<StaticEmojiInfoLogic>(builder:(logic){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('选择图集:',style: TextStyle(color: Colors.grey),),
          Obx(()=>DropdownButton(
              value: staticEmojiInfoLogic.selectedValue.value,
              icon: Icon(Icons.arrow_drop_down,size: 24,),
              isExpanded: true,
              underline: Container(height: 1, color: Colors.grey),
              items: staticEmojiInfoLogic.items,
              onChanged: (value) {
                staticEmojiInfoLogic.selectedValue.value = int.parse(value.toString());
                staticEmojiInfoLogic.selectedPath=staticEmojiInfoLogic.pathList[staticEmojiInfoLogic.selectedValue.value];
              }
          ))
        ],
      );
    });

  }

}
