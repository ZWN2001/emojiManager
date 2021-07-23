import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MakePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Scaffold(
      appBar: AppBar(title: Text('制作表情包'),),
      body:  Container(
        alignment: Alignment.center,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height/12,),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.amber[50],
                  side:BorderSide(color:Colors.amber) ,
                  minimumSize: Size(width*0.6, height/8),
                  shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
                  ),
              ),
              child: Text('制作静态表情包', style: TextStyle(fontSize: 24),),
              onPressed: () {

              },
            ),

            SizedBox(height: height/9),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.amber[50],
                side:BorderSide(color:Colors.amber) ,
                minimumSize: Size(width*0.6, height/8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
              ),
              child: Text('制作动态表情包', style: TextStyle(fontSize: 24),),
              onPressed: () {

              },
            ),

            SizedBox(height: height/9),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.amber[50],
                side:BorderSide(color:Colors.amber) ,
                minimumSize: Size(width*0.6, height/8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
              ),
              child: Text('表情包放大', style: TextStyle(fontSize: 24),),
              onPressed: () {

              },
            )
          ],
        ),
      )

    );
  }

}