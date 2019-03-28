import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

void main() {
  runApp(
      new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: new Scaffold(
              appBar: new AppBar(title: new Text("Find your favorite color app")),
              body: new GestureClass()
          )
      )
  );
}

class GestureClass extends StatefulWidget{
  GestureClassState createState() => GestureClassState();
}

class GestureClassState extends State<GestureClass> {

  Color _color = Color(0xffffffff);
  Random _random = new Random();

  List<Color> _historyColor = new List();

  GestureClassState(){
    _historyColor.add(_color);
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: (){
          changeColor();
        },
        child: new Container(
          color: _historyColor != null && _historyColor.length > 0 ?_historyColor[_historyColor.length-1] : _color,
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new Text("Hey there", style: TextStyle(color: Colors.black, fontSize: 20),),
                ),
                _historyColor.length > 1 ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new Text("Current color: " + getColorHex(_historyColor[_historyColor.length-1].toString()), style: TextStyle(color: Colors.black54, fontSize: 16),),
                ) : Container(),
                _historyColor.length > 1 ?  new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new FloatingActionButton.extended(
                      onPressed: (){
                        copyToClipboard(getColorHex(_historyColor[_historyColor.length-1].toString()));
                      },
                      icon: Icon(Icons.content_copy),
                      label: Text("Copy"),
                    ),
                    new FloatingActionButton.extended(
                      onPressed: (){
                        undo();
                      },
                      icon: Icon(Icons.undo),
                      label: Text("Undo"),
                    )],
                ) : new Container(height: 0, width: 0,)],
            ),
          ),
        )
    );
  }

  void changeColor() {
    setState(() {
      _color = Color.fromARGB(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
      );
      _historyColor.add(_color);
    });
  }

  void undo() {
    setState(() {
      if(_historyColor.length>1)
        _historyColor.removeLast();
    });
  }

  String getColorHex(String t){
    return "#" + t.substring(t.lastIndexOf("x")+1, t.length-1);
  }

  void copyToClipboard(String hexColor) {
    Clipboard.setData(new ClipboardData(text: getColorHex(_historyColor[_historyColor.length-1].toString())));
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(hexColor +  ' copied to clipboard'),
      duration: Duration(seconds: 2),
    ));
  }
}