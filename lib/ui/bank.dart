import 'dart:io';

import 'package:emoji_manager/ui/pic_album_page.dart';
import 'package:emoji_manager/util/directory_util.dart';
import 'package:emoji_manager/widget/dialog/text_field_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class BankPage extends StatefulWidget{
  BankPageState createState() => new BankPageState();
}

class BankPageState extends State<BankPage> {

  final String rootName = "emojiManager";
  final TextEditingController _vc = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<FileSystemEntity> files = [];
  late Widget topLeftWidget;
  late Widget topRightWidget;
  late StateSetter setter;
  Icon checkIcon = Icon(Icons.check_circle_outline,color: Colors.green);
  Icon uncheckIcon = Icon(Icons.radio_button_unchecked,color: Colors.white,);
  int count = 1;

  List<int> _selectedIndexList = [];
  bool _selectionMode = false;
  List<String> tempImageList = [
    'https://www.itying.com/images/flutter/1.png',
    'https://www.itying.com/images/flutter/2.png',
    'https://www.itying.com/images/flutter/3.png',
    'https://www.itying.com/images/flutter/4.png'
  ];

  //添加图集操作
  _addPicAlbum() async {
    String albumName = _vc.text;
    DirectoryUtil().createDir(albumName).then((value) {
      DirectoryUtil().dirList(rootName);
      _getDirList(rootName).then((value) {
        print(files.length);
        _vc.clear();
        setState(() {

        });
      });
    });
  }

  //获取所有图集的路径
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
  }

  //改变长按选择项，enable是true为选中状态，false为未选中状态
  void _changeSelection({required bool enable, required int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  //改变顶部导航栏样式
  Future _changeTopWidget() async {
    if (count % 2 == 1) {
      topRightWidget = topRightSecondWidget();
      topLeftWidget = topLeftSecondWidget();
      print('1');
    } else if (count % 2 == 0) {
      topRightWidget = topRightFirstWidget();
      topLeftWidget = topLeftFirstWidget();
      print('2');
    }
    print('change the widget');
    count++;
    this.setter(() {

    });
  }


  Future _onRefresh() async {

  }

  @override
  void initState() {
    super.initState();
    topLeftWidget = topLeftFirstWidget();
    topRightWidget = topRightFirstWidget();
    DirectoryUtil().dirList(rootName).then((value) {
      DirectoryUtil().dirList(rootName);
      _getDirList(rootName).then((value) {
        print(files.length);
        setState(() {

        });
      });

    });
  }

  //主界面
  @override
  Widget build(BuildContext context) {
    List<Widget> _buttons = [];
    if (_selectionMode) {
      _buttons.add(IconButton(
          onPressed: () {
            _selectedIndexList.sort();
            print('Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
            },
          icon: Icon(Icons.delete)));
    }
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          setter = setState;
          return Scaffold(
            appBar: AppBar(
              title: topLeftWidget,
              actions: [
                topRightWidget
              ],
            ),
            body: files.length == 0
                ? noDirText()
                : albumGridView(),
          );
        });

  }

  //没有图集时的界面
  Widget noDirText() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(
                Icons.collections,
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
  /*Widget albumGridView() {
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
  */
  Widget albumGridView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      primary: false,
      itemCount: files.length,
      itemBuilder: (BuildContext context, int index) {
        return gridItem(index);
        },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: EdgeInsets.all(4),
    );
  }

  //单个图集预览图
  Widget gridItem(int index) {
    String name = files.elementAt(index).path.substring(files.elementAt(index).parent.path.length+1);
    if (_selectionMode) {  //如果已长按，显示多选效果
      return GridTile(
        header: GridTileBar(
          leading: _selectedIndexList.contains(index) ? checkIcon : uncheckIcon
        ),
        footer: Text(
          name,
          style: TextStyle(fontSize: 18),),
        child: GestureDetector(
          child: Container(
            /*decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white,
                    width: 2)
            ),*/
            child: Image.network(tempImageList[index], fit: BoxFit.cover,),
          ),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: false, index: -1);
              _changeTopWidget().then((value) {
                this.setter(() {

                });
              });
            });
            },
          onTap: () {
            setState(() {
              if (_selectedIndexList.contains(index)) {
                _selectedIndexList.remove(index);
              } else {
                _selectedIndexList.add(index);
              }
            });
            },
        ),
      );
    } else {               //如果未长按，显示默认效果
      return GridTile(
        footer: Text(
          name,
          style: TextStyle(fontSize: 18),),
        child: InkResponse(
          child: Image.network(tempImageList[index], fit: BoxFit.cover,),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
              _changeTopWidget().then((value) {
                this.setter(() {

                });
              });
            });
            },
          onTap: () {
            Get.to(() => new PicAlbumPage(dirName: name,));
          },
        ),
      );
    }
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

  //第二个appBar左边，取消按钮
  Widget topLeftSecondWidget() {
    return IconButton(
        onPressed: () {
          setState(() {
            _changeSelection(enable: false, index: -1);
            _changeTopWidget().then((value) {
              this.setter(() {

              });
            });
          });
        },
        icon: Icon(Icons.clear));
  }

  //第二个appBar右边，小列表，包括全选、重命名、删除
  Widget topRightSecondWidget() {
    return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              enabled: _selectedIndexList.length == files.length ? false : true,
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
              enabled: _selectedIndexList.length > 1 ? false : true,
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
          if (str == 'all_select') {
            for (int i = 0; i < files.length; i++) {
              if (!_selectedIndexList.contains(i)) {
                _selectedIndexList.add(i);
              }
            }
            setState(() {

            });
          } else if (str == 'rename') {
            showDialog(
                context: context,
                builder: (context) {
                  return TextFieldDialog(
                      contentWidget: TextFieldDialogContent(
                        title: "请输入图集的新名字",
                        okBtnTap: () {
                          int i = _selectedIndexList.elementAt(0);
                          DirectoryUtil().dirRename(
                              files.elementAt(i).path.substring(files.elementAt(i).parent.path.length+1),
                              _vc.text).then((value) {
                                _getDirList(rootName).then((value) {
                                  setState(() {
                                    _changeSelection(enable: false, index: -1);
                                    _changeTopWidget().then((value) {
                                      this.setter(() {

                                      });
                                    });
                                  });
                                });
                          });
                        },
                        vc: _vc,
                        cancelBtnTap: () {
                          print('click cancel');
                        },
                      ));
                });
          } else if (str == 'delete') {
            for (int i = 0; i < _selectedIndexList.length; i++) {
              int j = _selectedIndexList.elementAt(0);
              DirectoryUtil().deleteDir(
                  files.elementAt(j).path.substring(files.elementAt(j).parent.path.length+1)).then((value) {
                _getDirList(rootName).then((value) {
                  setState(() {
                    _changeSelection(enable: false, index: -1);
                    _changeTopWidget().then((value) {
                      this.setter(() {

                      });
                    });
                  });
                });
              });
            }
          }
      },
    );
  }

}