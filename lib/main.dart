
import 'package:emoji_manager/ui/bank.dart';
import 'package:emoji_manager/ui/make.dart';
import 'package:emoji_manager/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  late PageController pageController;
  int page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: this.page);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: PageView(
            children: <Widget>[BankPage(), ImageEditorDemo(), SettingPage()],
            onPageChanged: onPageChanged,
            controller: pageController,
          ),
          floatingActionButton: FloatingActionButton(
            // elevation: 6.0,
            highlightElevation: 8.0,
            onPressed: () {
              onTap(1);
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
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
                        onTap(0);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.image, color: getColor(0)),
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
                      Text("添加", style: TextStyle(color: Color(0xFFEEEEEE)))
                    ],
                  ),
                  GestureDetector(
                      onTap: () {
                        onTap(2);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.settings, color: getColor(2)),
                          Text("设置", style: TextStyle(color: getColor(2)))
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          int newTime = DateTime.now().millisecondsSinceEpoch;
          int result = newTime - lastTime;
          lastTime = newTime;
          if (result > 2000) {
          } else {
            SystemNavigator.pop();
          }
          return false;
        });
  }

  void onPageChanged(int value) {
    setState(() {
      this.page = value;
    });
  }

  Color getColor(int value) {
    return this.page == value
        ? Theme.of(context).cardColor
        : Color(0XFFBBBBBB);
  }

  void onTap(int value) {
    pageController.animateToPage(value,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}

