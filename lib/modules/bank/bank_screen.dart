
import 'dart:io';
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
        title: topLeftFirstWidget(),
        actions: [
          topRightFirstWidget(context)
        ],
      ),
      body: Obx(() =>
      controller.files.isEmpty
          ? noDirText()
          : albumGridView(context)
      ),
    );
  }

  //没有图集时的界面
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

  //有图集时的界面
  Widget albumGridView(BuildContext context) {
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
  }

  //第一个appBar左边，文字“表情包库”
  Widget topLeftFirstWidget() {
    return Text("表情包库");
  }

  //第一个appBar右边，添加图集按钮
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
                      vc: controller.tc,
                      cancelBtnTap: () {
                        print('click cancel');
                      },
                    ));
              });
        },
        icon: Icon(Icons.add)
    );
  }

  //第二个appBar左边，全选Text
  Widget topLeftSecondWidget() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
        child: Text("全选"),
      ),
      onTap: () {
        //TODO:全选操作
      },
    );
  }

  //第二个appBar右边，取消

  //单个图集的封面
  Widget albumWidget(int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Ink(
        decoration: BoxDecoration(
        ),
        child: InkWell(
          onTap: () {
            //TODO:进入图集页面
          },
          onLongPress: () {
            //TODO:进入多选，appBar改变
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
  }

}