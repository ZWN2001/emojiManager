import 'package:flutter/material.dart';

///带有TextField的dialog

class TextFieldDialog extends AlertDialog {
  TextFieldDialog({required Widget contentWidget})
      : super (
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.deepOrangeAccent,width: 1)
      )
  );
}

double btnHeight = 60;
double borderWidth = 2;

class TextFieldDialogContent extends StatefulWidget {
  final String title; //标题
  final String cancelBtnTitle; //取消按钮文本
  final String okBtnTitle; //确认按钮文本
  final VoidCallback cancelBtnTap;
  final VoidCallback okBtnTap;
  final TextEditingController vc;
  TextFieldDialogContent({
    required this.title,
    this.cancelBtnTitle = "取消",
    this.okBtnTitle = "确认",
    required this.cancelBtnTap,
    required this.okBtnTap,
    required this.vc
  });

  @override
  _TextFieldDialogContentState createState() =>
      _TextFieldDialogContentState();
}

class _TextFieldDialogContentState extends State<TextFieldDialogContent> {

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 200,
      width: 10000,
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.title,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextField(
              style: TextStyle(color: Colors.black87),
              controller: widget.vc,
              onChanged: (String title) {
                setState(() {
                  _isComposing = title.length > 0;
                });
              },
              decoration: InputDecoration(
                  hintText: "新图集",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrangeAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrangeAccent),
                  )
              ),
            ),
          ),
          Container(
            height: btnHeight,
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.deepOrangeAccent,
                  height: borderWidth,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          widget.vc.text = "";
                          widget.cancelBtnTap();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style: TextStyle(fontSize: 22, color: Colors.deepOrangeAccent),
                        )),
                    Container(
                      width: borderWidth,
                      color: Colors.deepOrangeAccent,
                      height: btnHeight - borderWidth - borderWidth,
                    ),
                    TextButton(
                        onPressed: _isComposing ?
                            () {
                          widget.okBtnTap();
                          Navigator.of(context).pop();
                          widget.vc.text = "";
                        } : null,
                        child: Text(
                          widget.okBtnTitle,
                          style: TextStyle(fontSize: 22, color: Colors.deepOrangeAccent),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}