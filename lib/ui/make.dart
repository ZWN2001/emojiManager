import 'dart:typed_data';

import 'package:emoji_manager/util/image_edit_util/image_picker_io.dart';
import 'package:emoji_manager/util/icon_util/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MakePage extends StatelessWidget{
  @override
  Widget build(context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Scaffold(
      appBar: AppBar(title: Text('制作表情包'),),
      body:  Container(
        alignment: Alignment.center,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height/12,),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.amber[50],
                  side:BorderSide(color:Colors.amber) ,
                  minimumSize: Size(width*0.6, height/8),
                  shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
                  ),
              ),
              child: Text('制作静态表情包', style: TextStyle(fontSize: 24),),
              onPressed: () async {
                Uint8List? _memoryImage = await pickImage(context);
                if(_memoryImage!=null){
                  Get.toNamed("/StaticEmojiInfo",arguments: _memoryImage);
                }
              },
            ),

            SizedBox(height: height/9),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.amber[50],
                side:BorderSide(color:Colors.amber) ,
                minimumSize: Size(width*0.6, height/8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
              ),
              child: Text('制作动态表情包', style: TextStyle(fontSize: 24),),
              onPressed: () {
                Get.to(()=>CustomIcons());
              },
            ),

            SizedBox(height: height/9),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.amber[50],
                side:BorderSide(color:Colors.amber) ,
                minimumSize: Size(width*0.6, height/8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
              ),
              child: Text('表情包放大', style: TextStyle(fontSize: 24),),
              onPressed: () {

              },
            )
          ],
        ),
      )
    );
  }

}