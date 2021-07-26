
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PicInfoPage extends StatefulWidget {

  final String imagePath;
  PicInfoPage({required this.imagePath});

  PicInfoPageState createState() => PicInfoPageState(imagePath);
}

class PicInfoPageState extends State<PicInfoPage> {

  String imagePath = '';
  String name = "tempName"; //TODO: temp name
  String keyWord = "tempKeyWord"; //TODO: temp key word
  TextEditingController nameController = TextEditingController();
  TextEditingController keyWordController = TextEditingController();

  PicInfoPageState(String imagePath) {
    this.imagePath = imagePath;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("表情详情"),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(40, 80, 40, 20),
            child: Image.network(imagePath,fit: BoxFit.cover),
            //TODO: temp instance ...-> FileImage(File(imagePath))
            /*Image(
              image: FileImage(File(imagePath)),
              fit: BoxFit.cover,)*/
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(80, 0, 80, 10),
              child: Row(
                children: [
                  Expanded(child: Text("名称："),),

                  Expanded(
                      child:  TextField(
                        controller: nameController..text = name,
                        autofocus: false,
                      ),)

                ],
              ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(80, 0, 80, 30),
            child: Row(
                children: [
                  Expanded(child:  Text("关键字："),),
                  Expanded(
                      child: TextField(
                        controller: keyWordController..text = keyWord,
                        autofocus: false,
                      ))
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
                    minimumSize: Size(40, 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    primary: Colors.amber,
                    onPrimary: Colors.white
                  ),
                  child: Text("确认修改",style: TextStyle(fontSize: 12),),
                  onPressed: () {
                    //TODO: 修改图片名称和关键字
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(40, 25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      primary: Colors.amber,
                      onPrimary: Colors.white
                  ),
                  child: Text("修改位置",style: TextStyle(fontSize: 12),),
                  onPressed: () {
                    //TODO: 修改图片位置
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(40, 25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      primary: Colors.amber,
                      onPrimary: Colors.white
                  ),
                  child: Text("删除",style: TextStyle(fontSize: 12),),
                  onPressed: () {
                    //TODO: 删除图片
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}