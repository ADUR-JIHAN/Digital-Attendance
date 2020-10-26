import 'package:XmPrep/LIVEATTEND/attend_class.dart';
import 'package:XmPrep/LIVEATTEND/routine.dart';
import 'package:XmPrep/model/enrollment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class LiveClass extends StatefulWidget {
  LiveClass(this.pic,this.name);
  String pic,name;
  @override
  _LiveClass createState() => _LiveClass(pic,name);
}

class _LiveClass extends State<LiveClass> {
  String pic,name;
  _LiveClass(this.pic,this.name);
  @override
  Widget build(BuildContext context) {
    List<T> map<T>(List list, Function handler) {
      List<T> result = [];
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }
      return result;
    }
    final today = DateTime.now();
    int _current = 0;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(

        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Positioned(
                top: 0,
                height:height*0.6,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: const Radius.circular(30),
                  ),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 8, left: 26, right: 16, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "${DateFormat("EEEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                             name,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 34,
                              color: Colors.deepOrange,
                            ),
                          ),
                          trailing: _RadialProgress(
                            width: width * 0.2,
                            height: width * 0.2,
                            progress: 0.2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            ClipOval(
                                child: Image.network(
                                  pic,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.fitWidth,
                                )),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _IngredientProgress(
                                  ingredient: "Present",
                                  progress: 0.3,
                                  progressColor: Colors.green,
                                  leftAmount: 72,
                                  width: width * 0.28,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _IngredientProgress(
                                  ingredient: "Absent",
                                  progress: 0.2,
                                  progressColor: Colors.red,
                                  leftAmount: 22,
                                  width: width * 0.28,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height,
                left: 0,
                right: 0,
                bottom: 2,
                child: Routine(),
              ),

            ],
          ),
        )
    );
  }
}
class _RadialProgress extends StatelessWidget {
  final double height, width, progress;

  const _RadialProgress({Key key, this.height, this.width, this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress: .8,
      ),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "80",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF200087),
                  ),
                ),
                TextSpan(text: "\n"),
                TextSpan(
                  text: "%",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF200087),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _RadialPainter extends CustomPainter {
  final double progress;

  _RadialPainter({this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = Color(0xFF200087)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class _IngredientProgress extends StatelessWidget {
  final String ingredient;
  final int leftAmount;
  final double progress, width;
  final Color progressColor;

  const _IngredientProgress(
      {Key key,
        this.ingredient,
        this.leftAmount,
        this.progress,
        this.progressColor,
        this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 10,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height: 10,
                  width: width * progress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: progressColor,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Text("${leftAmount}classes"),
          ],
        ),
      ],
    );
  }
}