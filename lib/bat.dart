import 'package:flutter/material.dart';

class bat extends StatelessWidget{
  final double width;
  final double height;
  bat(this.width,this.height);

  Widget build(BuildContext context){
    return Container(
      height: height,
      width: width,
      decoration: new BoxDecoration(
        color: Colors.blueAccent
      ),
    );
  }
}