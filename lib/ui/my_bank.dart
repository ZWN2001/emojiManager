import 'dart:io';

import 'package:emoji_manager/util/directory_util.dart';
import 'package:emoji_manager/widget/dialog/text_field_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class BankPage1 extends StatefulWidget{
  BankPageState1 createState() => new BankPageState1();
}

class BankPageState1 extends State<BankPage1> {

  final String rootName = "emojiManager";
  final TextEditingController _vc = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<FileSystemEntity> files = [];


  _addPicAlbum() async {
    String albumName = _vc.text;
    DirectoryUtil().createDir(albumName).then((value) {
      DirectoryUtil().dirList(rootName);
      _getDirList(rootName);
    });
    _vc.clear();
    setState(() {

    });
  }

  Future _getDirList(String dirName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path;
    if (dirName == "emojiManager") {
      path = '${documentsDirectory.path}${Platform.pathSeparator}$dirName';
    } else {
      path = '${documentsDirectory.path}${Platform.pathSeparator}'+"emojiManager"+'${Platform.pathSeparator}$dirName';
    }
    var directory = Directory(path);
    files = directory.listSync();
    print(files.length);
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
      body: albumGridView(),
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
      child: ListView.builder(
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //   crossAxisCount: 1,
          //   // crossAxisSpacing: 5,
          //   mainAxisSpacing: 5
          // ),
          // padding: EdgeInsets.symmetric(horizontal: 0),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          itemCount: files.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.red,
              child:ListTile(
                leading: Icon(Icons.assessment_outlined),
                title:Text(files[index].path.substring(64)) ,
              ),
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
    return ListTile(
      title:Text(files[index].path) ,
    );
    //   InkWell(
    //   onTap: () {
    //     //TODO:进入图集页面
    //   },
    //   onLongPress: () {
    //     //TODO:进入多选，appBar改变
    //   },
    // );
  }

}