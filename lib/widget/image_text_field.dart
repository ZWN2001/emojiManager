import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageTextField extends StatefulWidget {
  ImageTextField(
     this.x,
     this.y,
     this.textColor,
     this.bgW,
     this.bgH,
     this.onLoseFocus,
);
  TextEditingController _textController = new TextEditingController();
  FocusNode _focusNode = FocusNode();

  final Color textColor;
  late double _textSize;
  late TextStyle _textStyle;

  //宽，高，位置,倾斜角度
  late double _width;
  late double _height;
  late double x;
  late double y;
  late double rotation=0;

  //临时变量
  late double _tempTextSize;
  late Offset _lastOffset;

  String inputText='';

  //背景的宽高
  final double bgW;
  final double bgH;

  VoidCallback? onLoseFocus;
  @override
  ImageTextFieldState createState() => new ImageTextFieldState();
}

class ImageTextFieldState extends State<ImageTextField> {

  @override
  void initState() {
    super.initState();

    widget._textSize=28.0;
    widget._textStyle=TextStyle(color: widget.textColor,fontSize: widget._textSize);
    widget._tempTextSize=widget._textSize;
    widget._width = 0;
    widget._height = 70;

    widget._focusNode.addListener((){
      if (widget._focusNode.hasFocus) {
        print('得到焦点');
      }else{
        widget.onLoseFocus!();
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
                child: GestureDetector(
                  child:Transform.rotate(
                    angle: widget.rotation,
                    child:Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 5),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),)),
                      width:widget._width+70,height:widget._height+24,
                      child:Stack(
                        children: [
                          Positioned(
                            left: 10, top: 30,
                            child: SizedBox(
                              width: widget._width+30,
                              height: widget._height,
                              child:  TextField(
                                focusNode: widget._focusNode,
                                controller: widget._textController,
                                autofocus: true,
                                style: widget._textStyle,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                  border:InputBorder.none,
                                ),
                                // maxLength: 10,
                                onChanged: (value){
                                  setState(() {
                                    widget.inputText=widget._textController.text;
                                    widget._width =
                                        boundingTextSize(widget._textController.text, widget._textStyle).width;
                                  });
                                },
                              )  ,
                            ),
                          ),
                          Positioned(
                            child: Material(
                              type: MaterialType.circle,
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              child:IconButton(
                                onPressed: (){widget._textController.text='';},
                                icon: Icon(Icons.delete_forever,size: 26,),
                              ) ,
                            ),
                            left: widget._width+22,
                            top: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onScaleEnd: scaleEnd,
                  onScaleStart: scaleStart,
                  onScaleUpdate: scaleUpdate,
                ),
                left: widget.x, top: widget.y,
              );
  }

  //开始缩放
  void scaleStart(ScaleStartDetails details){
    widget._tempTextSize=widget._textSize;
    widget._lastOffset = details.focalPoint;
  }

  void scaleUpdate(ScaleUpdateDetails details){
    if (details.rotation != 0) {
      widget.rotation = details.rotation;
    }
    setState(() {
      widget._textSize = widget._tempTextSize*details.scale.clamp(0.8, 2);
      widget._textStyle = TextStyle(color: widget.textColor,fontSize: widget._textSize);
      widget._width = boundingTextSize(widget._textController.text, widget._textStyle).width;
      widget._height = widget._textController.text==''?
      boundingTextSize(widget._textController.text, widget._textStyle).height :70;
      widget.x += (details.focalPoint.dx - widget._lastOffset.dx);
      widget.y += (details.focalPoint.dy - widget._lastOffset.dy);
      if(widget.x < 0){
        widget.x = 0;
      }
      if(widget.y < 0){
        widget.y = 0;
      }
      if(widget.x > widget.bgW - widget._width){
        widget.x = widget.bgW - widget._width;
      }
      if(widget.y > widget.bgH - widget._height){
        widget.y = widget.bgH - widget._height;
      }
      widget._lastOffset = details.focalPoint;
    });
  }

  //缩放结束
  void scaleEnd(ScaleEndDetails details){
    widget._tempTextSize=widget._textSize;
  }

  Size boundingTextSize(String text, TextStyle style,  {int maxLines = 2^31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size(0,70);
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style), maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  @override
  void dispose() {
    super.dispose();
    widget._focusNode.dispose();
  }
}
