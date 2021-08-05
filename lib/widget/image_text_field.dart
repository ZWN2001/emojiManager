import 'package:flutter/material.dart';

class ImageTextField extends StatefulWidget {
  ImageTextField(
      this.x,
      this.y,
      this._textColor,
      this._textSize,
      this._onDelete,
      this._bgW,
      this._bgH
     );

  GlobalKey _globalKey = new GlobalKey();
  TextEditingController _textController = new TextEditingController();
  // FocusNode _focusNode = FocusNode();

  late Color _textColor;
  late double _textSize;
  late TextStyle _textStyle;

  //宽，高，位置,倾斜角度
  late double _width;
  late double _height;
  double x=50;
  double y=200;
  late double rotation=0;

  //临时变量
  late double _tempTextSize;
  late Offset _lastOffset;

  //背景的宽高
  late double _bgW;
  late double _bgH;

  VoidCallback? _onDelete;
  @override
  ImageTextFieldState createState() => new ImageTextFieldState();
}

class ImageTextFieldState extends State<ImageTextField> {

  @override
  void initState() {
    super.initState();

    widget._textSize=28.0;
    widget._textColor=Colors.black;
    widget._textStyle=TextStyle(color: widget._textColor,fontSize: widget._textSize);
    widget._tempTextSize=widget._textSize;
    widget._width = 0;
    widget._height = 70;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(key:widget._globalKey, color: Colors.blueGrey, width: 400, height: 700,),
              Positioned(
                child: GestureDetector(
                  child:Transform.rotate(
                    angle: widget.rotation,
                    child:Container(
                      color: Colors.orange,
                      width:widget._width+70,height:widget._height+32,
                      child:Stack(
                        children: [
                          Positioned(
                            left: 10, top: 30,
                            child: SizedBox(
                              width: widget._width+30,
                              height: widget._height,
                              child:  TextField(
                                // focusNode: widget._focusNode,
                                controller: widget._textController,
                                autofocus: true,
                                style: widget._textStyle,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                  border:InputBorder.none,
                                ),
                                maxLength: 10,
                                onChanged: (value){
                                  setState(() {
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
                                onPressed: (){print('a');},
                                icon: Icon(Icons.delete_forever,size: 26,),
                              ) ,
                            ),
                            left: widget._width+30,
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
              ),
            ],
          )
      ),);
  }
  //计算背景的宽高
  void getBgInfo(){
    widget._bgW=600;
    widget._bgH=500;
  }

  //开始缩放
  void scaleStart(ScaleStartDetails details){
    widget._tempTextSize=widget._textSize;
    widget._lastOffset = details.focalPoint;
    getBgInfo();
  }

  void scaleUpdate(ScaleUpdateDetails details){
    if (details.rotation != 0) {
      widget.rotation = details.rotation;
    }
    setState(() {
      widget._textSize = widget._tempTextSize*details.scale.clamp(0.8, 2);
      widget._textStyle = TextStyle(color: widget._textColor,fontSize: widget._textSize);
      widget._width = boundingTextSize(widget._textController.text, widget._textStyle).width;
      widget._height = boundingTextSize(widget._textController.text, widget._textStyle).height;
      widget.x += (details.focalPoint.dx - widget._lastOffset.dx);
      widget.y += (details.focalPoint.dy - widget._lastOffset.dy);
      if(widget.x < 0){
        widget.x = 0;
      }
      if(widget.y < 0){
        widget.y = 0;
      }
      if(widget.x > widget._bgW - widget._width){
        widget.x = widget._bgW - widget._width;
      }
      if(widget.y > widget._bgH - widget._height){
        widget.y = widget._bgH - widget._height;
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
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style), maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
}
