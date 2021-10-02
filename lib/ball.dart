import 'package:flutter/material.dart';
class Ball extends StatelessWidget{
  Widget build(BuildContext context){
    final double diam=50;
    return Container(
      width: diam,
      height: diam,
      decoration: new BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle
      ),
    );
  }
}