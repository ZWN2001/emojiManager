import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
class StaticEmojiInfo extends StatefulWidget{
  @override
  _StaticEmojiInfoState createState()=>_StaticEmojiInfoState();
}
class _StaticEmojiInfoState extends State<StaticEmojiInfo> {
  TextEditingController _nameEditController = new TextEditingController();
  TextEditingController _keyWordEditController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Uint8List? _memoryImage =
        ModalRoute.of(context)!.settings.arguments as Uint8List?;
    return Scaffold(
        appBar: AppBar(
          title: const Text('制作静态表情包'),
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(40, 80, 40, 20),
              child: Image.memory(
                _memoryImage!,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(80, 0, 80, 10),
              child: TextField(
                autofocus: false,
                controller: _nameEditController,
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
                controller: _keyWordEditController,
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
                  if(_nameEditController.text==''||_nameEditController.text.isEmpty){
                    Fluttertoast.showToast(msg: '名称不能为空',toastLength: Toast.LENGTH_SHORT);
                  }else{
                    Map emojiInfo={
                      'name':_nameEditController.text,
                      'keyWord':_keyWordEditController.text,
                      'image':_memoryImage
                    };
                    Get.toNamed("/ImageEditPage",arguments: emojiInfo);
                  }
                },
              ),
            ),
          ],
        ));
  }
}
