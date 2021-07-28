import 'package:emoji_manager/modules/bank/pic_album_controller.dart';
import 'package:emoji_manager/modules/bank/pic_info_controller.dart';
import 'package:emoji_manager/modules/bank/pic_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class PicAlbumScreen extends GetView<PicAlbumController> {

  /*late final String dirName;
  PicAlbumScreen(String dirName) {
    this.dirName = dirName;
    controller.dirName = this.dirName;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.dirName),
      ),
      body: Obx(() => controller.tempImageList.length == 0
          ? noPicText()
          : picGridView()),
      //TODO: tempImageList -> imageList.value
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
      itemCount: controller.tempImageList.length,  //TODO: tempImageList -> imageList
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
          child: Image.network(controller.tempImageList.elementAt(index),fit: BoxFit.cover,),
          //TODO: temp instance, Image.network() -> imageList.elementAt(index)
          onTap: () {
            Get.to(() => PicInfoScreen(),
                binding: PicInfoBinding(controller.tempImageList.elementAt(index).toString()));
            //TODO: temp instance ... -> imagePath: picPathList.elementAt(index).toString();
          },
        )
    );
  }

}