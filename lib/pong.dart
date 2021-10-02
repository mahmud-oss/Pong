import 'package:flutter/material.dart';
import 'package:pong_games/ball.dart';
import 'package:pong_games/bat.dart';
import 'dart:math';
enum Direction {Up, Down, Left, Right}

class pong extends StatefulWidget{
  _PongState createState() => _PongState();
}

class _PongState extends State<pong> with SingleTickerProviderStateMixin{
  int score=0;
  Direction hdir=Direction.Right;
  Direction vdir=Direction.Up;
  late double width;
  late double height;
  double posX=0;
  double posY=0;
  double batWidth=0;
  double batHeight=0;
  double batPosition=0;
  double increment=5;
  double randX=1;
  double randY=1;
  late Animation<double> animation;
  late AnimationController controller;
  void initState(){
    posX=0;
    posY=0;
    controller=AnimationController(
        vsync: this,
      duration: const Duration(seconds: 10000)
    );
    animation=Tween<double>(begin: 0,end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        checkBorders();
        (hdir==Direction.Right)?posX+=((increment+randX).round()):
                               posX-=((increment+randX).round());
        (vdir==Direction.Down)?posY+=((increment+randY).round()):
                             posY-=((increment+randY).round());
      });
      checkBorders();
    });
    controller.forward();
    super.initState();
  }
  void checkBorders(){
    if(posX<=0 && hdir==Direction.Left){
      hdir=Direction.Right;
      randX=random();
    }
    if(posX>=width-50 && hdir==Direction.Right){
      hdir=Direction.Left;
      randX=random();
    }
    // if(posY>=height-50 && vdir==Direction.Down){
    //   vdir=Direction.Up;
    // }
    // if(posY<=0 && vdir==Direction.Up){
    //   vdir=Direction.Down;
    // }
    ///50 is the diameter of the ball
    if(posY>=height-50 && vdir==Direction.Down){
      if(posX>=(batPosition-50) && posX<=(batPosition+batWidth+50)){
        vdir=Direction.Up;
        randY=random();
        setState(() {
          score++;
        });
      }else{
        controller.stop();
        showMessage(context);
      }

    }
    if (posY <= 0 && vdir == Direction.Up) {
      vdir = Direction.Down;
      randY=random();
    }
  }
  ///pop-up msg
  void showMessage(BuildContext context){
    showDialog(
        context: context,
        builder:(BuildContext context){
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Would you like to play again?'),
            actions: <Widget>[
              TextButton(onPressed: (){
                setState(() {
                  posX=0;
                  posY=0;
                  score=0;
                });
                Navigator.of(context).pop();
                controller.repeat();
              },
                  child:Text('Yes') 
              ),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
                dispose();
              },
                  child: Text('No'))
            ],
          );
        }
    );
  }
  void moveBat(details){
    setState(() {
      batPosition+=details.delta.dx;
    });
  }
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  void safeSetState(Function function){
    if(mounted && controller.isAnimating){
      setState(() {
        function();
      });
    }
  }
  double random(){
    var ran=new Random();
    int myNum=ran.nextInt(101);
    return (50+myNum)/100;
  }
  Widget build(BuildContext context){
    return LayoutBuilder(
     builder: (BuildContext context, BoxConstraints constraint){
       height=constraint.maxHeight;
       width=constraint.maxWidth;
       batWidth=width/5;
       batHeight=height/20;
       return Stack(
         children: <Widget>[
           Positioned(
           child: Ball(),
             top: posY,
             left: posX,

       ),
           Positioned(
                   bottom: 0,
             left: batPosition,
             child:GestureDetector(
               onHorizontalDragUpdate: (details) => moveBat(details),
              child: bat(batWidth,batHeight),
             )
           ),
           Positioned(
               top:0,
             right: 26,
             child: Text('Score: '+score.toString()),
           )


         ],
       );
     }
    );
  }
}