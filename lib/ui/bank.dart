import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BankPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('表情包库'),
        actions: [
          IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.add)
          )
        ],
      ),
    );
  }

}