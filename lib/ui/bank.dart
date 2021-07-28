import 'dart:async';
import 'dart:io';

import 'package:emoji_manager/util/util.dart';
import 'package:emoji_manager/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BankPage extends StatefulWidget{
  BankPageState createState() => new BankPageState();
}

class BankPageState extends State<BankPage> {

  final String rootName = "emojiManager";
  final TextEditingController _vc = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<FileSystemEntity> files = [];


  _addPicAlbum() async {
    String albumName = _vc.text;
    await DirectoryUtil().createDir(albumName);
    DirectoryUtil().dirList(rootName);
    _getDirList(rootName);
    _vc.clear();
    setState(() {

    });
  }

  Future _getDirList(String dirName) async {
    files = Directory(await DirectoryUtil().getDirPath(dirName)).listSync();
  }


  Future _onRefresh() async {

  }

  @override
  void initState() {
    super.initState();
    DirectoryUtil().dirList(rootName).then((value) {
      DirectoryUtil().dirList(rootName);
      _getDirList(rootName);
      setState(() {

      });
    });
  }

  //主界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('表情包库'),
        actions: [
          IconButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return TextFieldDialog(
                          contentWidget: TextFieldDialogContent(
                            title: "请输入新图集名字",
                            okBtnTap: () {
                              _addPicAlbum();
                            },
                            vc: _vc,
                            cancelBtnTap: () {
                              print('click cancel');
                              },
                          ));
                    });
              },
              icon: Icon(Icons.add)
          )
        ],
      ),
      body: noDirText(),
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
  Widget albumGridView() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          itemCount: files.length,
          itemBuilder: (context, index) {
            return Material(
              child: albumWidget(index),
            );
          }),
    );
  }

  //第一个appBar左边，文字“表情包库”
  Widget topLeftFirstWidget() {
    return Text("表情包库");
  }

  //第一个appBar右边，添加图集按钮
  Widget topRightFirstWidget() {
    return IconButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (context) {
                return TextFieldDialog(
                    contentWidget: TextFieldDialogContent(
                      title: "请输入新图集名字",
                      okBtnTap: () {
                        _addPicAlbum();
                      },
                      vc: _vc,
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
  Widget albumWidget(int index) {
    return Ink(
      decoration: BoxDecoration(),
      child: InkWell(
        onTap: () {
          //TODO:进入图集页面
        },
        onLongPress: () {
          //TODO:进入多选，appBar改变
        },
      ),
    );
  }

}