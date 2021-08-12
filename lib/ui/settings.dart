import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Scaffold(
      appBar: AppBar(title: Text('设置'),),
      body: _buildSettingsPage(width,height),
    );
  }
  Widget _buildSettingsPage(double width,double height){
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.black,
              // backgroundColor: Colors.amber[50],
              side:BorderSide(color:Colors.amber) ,
              minimumSize: Size(width*0.6, height/8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            child: Text('表情包存储位置', style: TextStyle(fontSize: 24),),
            onPressed: ()  {

            },
          ),
          Expanded(child: SizedBox()),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.black,
              // backgroundColor: Colors.amber[50],
              side:BorderSide(color:Colors.amber) ,
              minimumSize: Size(width*0.6, height/8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            child: Text('关于', style: TextStyle(fontSize: 24),),
            onPressed: ()  {

            },
          ),
          Expanded(child: SizedBox()),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.black,
              // backgroundColor: Colors.amber[50],
              side:BorderSide(color:Colors.amber) ,
              minimumSize: Size(width*0.6, height/8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            child: Text('联系我们', style: TextStyle(fontSize: 24),),
            onPressed: ()  {

            },
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }

}