
import 'dart:io';

import 'package:emoji_manager/modules/bank/pic_album_controller.dart';
import 'package:emoji_manager/modules/bank/pic_album_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:emoji_manager/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:emoji_manager/widget/widget.dart';

import 'bank_controller.dart';


class BankScreen extends GetView<BankController> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Obx(() =>
        controller.selectionMode.isFalse
            ? topLeftFirstWidget()
            : topLeftSecondWidget()),
        actions: [
          Obx(() => controller.selectionMode.isFalse
              ? topRightFirstWidget(context)
              : topRightSecondWidget(context))
        ],
      ),
      body: Obx(() => controller.dirNameList.isEmpty
          ? noDirText()
          : albumGridView(context))
    );
  }

  ///没有图集时的界面
  Widget noDirText() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(
                Icons.wallpaper,
                size: 100,
                color: Colors.black38),
          ),
          Container(
            child: Text('你还没有创建图集',
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  ///有图集时的界面
  /*Widget albumGridView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          scrollDirection: Axis.vertical,
          controller: controller.scrollController,
          itemCount: controller.files.length,
          itemBuilder: (context, index) {
            return Material(
              child: albumWidget(index, context),
            );
          }),
    );
  }*/
  Widget albumGridView(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      primary: false,
      itemCount: controller.dirNameList.length,
      itemBuilder: (BuildContext context, int index) => gridItem(index),
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: EdgeInsets.all(4),
    );
  }

  ///单个图集预览图
  Widget gridItem(int index) {
    String name = controller.dirNameList.elementAt(index);
    return Obx(() =>
    controller.selectionMode.value
        ? selectedAlbum(index, name)
        : unselectedAlbum(index, name));
    /*if (controller.selectionMode.value) {   ///如果已长按，显示多选效果
      return GridTile(
        header: GridTileBar(
          leading: Obx(() =>
          controller.selectedIndexList.contains(index)
              ? controller.checkIcon
              : controller.uncheckIcon
          ),
        ),
        footer: Container(
          width: SizeConfig().screenWidth / 3,
          height: SizeConfig().screenWidth / 3 / 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 1],
              colors: [
                Colors.transparent,
                Colors.black54
              ]
            ),
          ),
          child: Text(
            name,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white),
          ),
        ),
        child: GestureDetector(
          child: Container(
            width: SizeConfig().screenWidth / 3,
            height: SizeConfig().screenWidth / 3,
            child: Image.network(
              controller.tempImageList[index],
              fit: BoxFit.cover,
            ),
          ),
          onLongPress: () {
            controller.changeSelection(enable: false, index: -1);
          },
          onTap: () {
            if (controller.selectedIndexList.contains(index)) {
              controller.selectedIndexList.remove(index);
            } else {
              controller.selectedIndexList.add(index);
            }
          },
        ),
      );
    } else {        ///如果未长按，显示默认效果
      return GridTile(
        footer: Container(
          width: SizeConfig().screenWidth / 3,
          height: SizeConfig().screenWidth / 3 / 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 1],
                  colors: [
                    Colors.transparent,
                    Colors.black54
                  ]
              ),
          ),
          child: Text(
            name,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white),
          ),
        ),
        child: GestureDetector(
          child: Container(
            width: SizeConfig().screenWidth / 3,
            height: SizeConfig().screenWidth / 3,
            child: Image.network(
              controller.tempImageList[index],
              fit: BoxFit.cover,
            ),
          ),
          onLongPress: () {
            controller.changeSelection(enable: true, index: index);
          },
          onTap: () {

          },
        ),
      );
    }*/
  }

  Widget selectedAlbum(int index, String name) {
    return GridTile(
      header: GridTileBar(
        leading: Obx(() =>
        controller.selectedIndexList.contains(index)
            ? controller.checkIcon
            : controller.uncheckIcon
        ),
      ),
      footer: Container(
        width: SizeConfig().screenWidth / 3,
        height: SizeConfig().screenWidth / 3 / 5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 1],
              colors: [
                Colors.transparent,
                Colors.black54
              ]
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
              fontSize: 20,
              color: Colors.white),
        ),
      ),
      child: GestureDetector(
        child: Container(
          width: SizeConfig().screenWidth / 3,
          height: SizeConfig().screenWidth / 3,
          child: controller.hasFirstPicList[index]
              ? Image(image: FileImage(File(controller.firstPicPathList[index])),fit: BoxFit.cover,)
              : Image.network( 'https://www.itying.com/images/flutter/4.png',fit: BoxFit.cover),
        ),
        onLongPress: () {
          controller.changeSelection(enable: false, index: -1);
        },
        onTap: () {
          if (controller.selectedIndexList.contains(index)) {
            controller.selectedIndexList.remove(index);
          } else {
            controller.selectedIndexList.add(index);
          }
        },
      ),
    );
  }

  Widget unselectedAlbum(int index, String name) {
    return GridTile(
      footer: Container(
        width: SizeConfig().screenWidth / 3,
        height: SizeConfig().screenWidth / 3 / 5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 1],
              colors: [
                Colors.transparent,
                Colors.black54
              ]
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
              fontSize: 20,
              color: Colors.white),
        ),
      ),
      child: GestureDetector(
        child: Container(
          width: SizeConfig().screenWidth / 3,
          height: SizeConfig().screenWidth / 3,
          child: controller.hasFirstPicList[index]
              ? Image(image: FileImage(File(controller.firstPicPathList[index])),fit: BoxFit.cover,)
              : Image.network( 'https://www.itying.com/images/flutter/4.png',fit: BoxFit.cover),
        ),
        onLongPress: () {
          controller.changeSelection(enable: true, index: index);
        },
        onTap: () {
          Get.to(() => new PicAlbumScreen(),binding: PicAlbumBinding(name));
        },
      ),
    );
  }

  ///第一个appBar左边，文字“表情包库”
  Widget topLeftFirstWidget() {
    return Text("表情包库");
  }

  ///第一个appBar右边，添加图集按钮
  Widget topRightFirstWidget(BuildContext context) {
    return IconButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (context) {
                return TextFieldDialog(
                    contentWidget: TextFieldDialogContent(
                      title: "请输入新图集名字",
                      okBtnTap: () {
                        controller.addPicAlbum();
                      },
                      vc: controller.addTc,
                      cancelBtnTap: () {
                        print('click cancel');
                      },
                    ));
              });
        },
        icon: Icon(Icons.add)
    );
  }

  ///第二个appBar左边，取消按钮
  Widget topLeftSecondWidget() {
    return IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        controller.changeSelection(enable: false, index: -1);
      },
    );
  }

  ///第二个appBar右边，小列表，包括全选、重命名、删除
  Widget topRightSecondWidget(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              enabled: controller.selectedIndexList.length
                  == controller.dirNameList.length
                  ? false : true,
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.check_circle,color: Colors.black87,)),
                  Text("全选")
                ],
              ),
              value: 'all_select',
            ),
            PopupMenuItem(
              enabled: controller.selectedIndexList.length > 1 ? false : true,
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.drive_file_rename_outline,color: Colors.black87,)),
                  Text("重命名")
                ],
              ),
              value: 'rename',
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.delete,color: Colors.black87,)),
                  Text("删除")
                ],
              ),
              value: 'delete',
            ),
          ];
        },
      onSelected: (String str) {
          controller.popMenuItemSelection(str, context);
      },
    );
  }

 /* //单个图集的封面
  Widget albumWidget(int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Ink(
        decoration: BoxDecoration(
        ),
        child: InkWell(
          onTap: () {

          },
          onLongPress: () {

          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Container(
              width: SizeConfig().screenWidth / 2,
              height: SizeConfig().screenWidth / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        // child: FlutterLogo(
                        //   size: SizeConfig().screenWidth / 3,
                        // ),
                        child: Icon(
                          Icons.image_not_supported,
                        )
                    ),
                  ),
                  Container(
                    width: SizeConfig().screenWidth / 2,
                    height: SizeConfig().screenWidth / 2 / 5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 1],
                            colors: [
                              Colors.transparent,
                              Colors.black54,
                            ]
                        ),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)
                        )
                    ),
                    child: Text(
                      "${controller.files[index].path.split(Platform.pathSeparator).last}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }*/

}