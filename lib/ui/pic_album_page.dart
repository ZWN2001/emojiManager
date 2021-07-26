import 'dart:io';

import 'package:emoji_manager/ui/pic_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class PicAlbumPage extends StatefulWidget {
  final String dirName;

  PicAlbumPage({required this.dirName});

  PicAlbumPageState createState() => new PicAlbumPageState(dirName);
}

class PicAlbumPageState extends State<PicAlbumPage> {

  String dirName = '';
  List<FileSystemEntity> picPathList = [];
  List<Image> imageList = [];

  List<String> tempImageList = [
    'https://www.itying.com/images/flutter/1.png',
    'https://www.itying.com/images/flutter/2.png',
    'https://www.itying.com/images/flutter/3.png',
    'https://www.itying.com/images/flutter/4.png'
  ];

  PicAlbumPageState(String dirName) {
    this.dirName = dirName;
  }

  Future _getPicPathList(String dirName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}${Platform.pathSeparator}'+'emojiManager'+'${Platform.pathSeparator}$dirName';
    var dir = Directory(path);
    picPathList = dir.listSync();
  }
  
  Future _getImageList() async {
    picPathList.forEach((element) { 
      imageList.add(Image(image: FileImage(File(element.toString())),fit: BoxFit.cover,));
    });
    print('finished');
  }

  @override
  void initState() {
    super.initState();
    _getPicPathList(dirName).then((value) {
      _getImageList().then((value) {
        setState(() {
          print(imageList.length);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dirName)
      ),
      body: tempImageList.length == 0 ? noPicText() : picGridView(), //TODO: temp instance,tempImageList -> imageList
    );
  }

  Widget noPicText() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(
              Icons.wallpaper,
              size: 100,
              color: Colors.black38,
            ),
          ),
          Container(
            child: Text(
              "这里还没有图片",
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget picGridView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      primary: false,
      itemCount: tempImageList.length,  //TODO: temp instance, tempImageList -> imageList
      itemBuilder: (BuildContext context, int index) {
        return imageItem(index);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: EdgeInsets.all(4),
    );
  }

  Widget imageItem(int index) {
    return GridTile(
        child: InkResponse(
          child: Image.network(tempImageList.elementAt(index),fit: BoxFit.cover,),
          //TODO: temp instance, Image.network() -> imageList.elementAt(index)
          onTap: () {
            Get.to(() => new PicInfoPage(imagePath: tempImageList.elementAt(index)));
            //TODO: temp instance ... -> imagePath: picPathList.elementAt(index).toString();
          },
        )
    );
  }

}