import 'package:emoji_manager/ui/bank.dart';
import 'package:emoji_manager/ui/image_edit_page.dart';
import 'package:emoji_manager/ui/make.dart';
import 'package:emoji_manager/ui/settings.dart';
import 'package:emoji_manager/ui/static_emoji_info.dart';
import 'package:emoji_manager/util/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(name: '/ImageEditPage', page:()=>ImageEditPage()),
        GetPage(name: '/StaticEmojiInfo', page:()=>StaticEmojiInfo()),
      ],
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int lastTime = 0;
  int index = 0;

  final List<Widget>  pages = [BankPage(), MakePage(), SettingPage()];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: pages[index],

          floatingActionButton: FloatingActionButton(
            // elevation: 6.0,
            highlightElevation: 8.0,
            onPressed: () {
              onPageChanged(1);
            },
            child: Icon(
              MyIcons.make,
              color: getColor(1),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).accentColor,
            shape: CircularNotchedRectangle(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        onPageChanged(0);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.image_outlined, color: getColor(0)),
                          Text("库", style: TextStyle(color: getColor(0)))
                        ],
                      )),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.home,
                        color: Colors.transparent,
                      ),
                      Text("制作", style: TextStyle(color: getColor(1)))
                    ],
                  ),
                  GestureDetector(
                      onTap: () {
                        onPageChanged(2);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.settings_outlined, color: getColor(2)),
                          Text("设置", style: TextStyle(color: getColor(2)))
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Fluttertoast.showToast(msg: '再按一次退出APP');
          int newTime = DateTime.now().millisecondsSinceEpoch;
          int result = newTime - lastTime;
          lastTime = newTime;
          if (result > 2500) {
          } else {
            SystemNavigator.pop();
          }
          return false;
        });
  }

  void onPageChanged(int value) {
    setState(() {
      this.index = value;
    });
  }

  Color getColor(int value) {
    return this.index == value
        ? Theme.of(context).cardColor
        : Color(0XFFBBBBBB);
  }
}

