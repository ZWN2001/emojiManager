import 'package:emoji_manager/modules/modules.dart';
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
      body: Obx(() => controller.imageList.length == 0
          ? noPicText()
          : picGridView()),
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
      itemCount: controller.imageList.length,
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
          child: controller.imageList.elementAt(index),
          //Image.network(controller.tempImageList.elementAt(index),fit: BoxFit.cover,),
          onTap: () async {
            await Get.to(() => PicInfoScreen(),
                binding: PicInfoBinding(
                    controller.picPathList.elementAt(index).path,
                    controller.dirName))
            !.then((value) => value == "refresh"
                ? controller.initAgain()
                : null
            );
          },
        )
    );
  }

}