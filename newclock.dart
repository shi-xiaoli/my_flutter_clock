import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:flare_dart/math/mat2d.dart';

const Pi = 3.1415926;

class NewClockPage extends StatefulWidget {
  @override
  NewClockPageState createState() => new NewClockPageState();
}

class NewClockPageState extends State<NewClockPage> with FlareController {
  double _currentAnimTime = 0.0;
  ActorNode _hour_ptr;
  ActorNode _min_ptr;
  ActorAnimation _numbers;
  double now_seconds = 0.0;
  List<String> citys;

  @override
  void initialize(FlutterActorArtboard artboard) {
    _numbers = artboard.getAnimation("number_blinks_as60s");
    _hour_ptr = artboard.getNode("Hour");
    _min_ptr = artboard.getNode("Minute");
    var n = new DateTime.now();
    now_seconds = 1.0 * (n.hour * 3600 + n.minute * 60 + n.second);
    citys = ["伦敦","巴黎", "雅典", "莫斯科", "阿布扎比", "新德里", "缅甸","新加坡",
      "北京", "东京", "墨尔本", "所罗门群岛", "新西兰惠灵顿"];
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    now_seconds += elapsed;
    now_seconds %= 24 * 3600;
    _hour_ptr.rotation = now_seconds / 3600 / 24.0 * 4 * Pi;
    _min_ptr.rotation = now_seconds / 60 / 60.0 * 2 * Pi;
    _numbers.apply(now_seconds % 60, artboard, 1);
    return true;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(
        child: _buildZoneList()
      ),
      body: new FlareActor("anime/Clock.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "number_blinks_as60s",
          controller: this));
  }

  Widget _buildZoneList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 13,
      itemBuilder: (context, i) {
        return _buildRow(citys[i], i-8);
      },
    );
  }

  Widget _buildRow(String city, int i) {
    return new ListTile(
      title: new Text(
        city,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      onTap: () {
        var now = new DateTime.now();
        now_seconds = 1.0 * (now.hour * 3600 + now.minute * 60 + now.second);
        setState(() { now_seconds = now_seconds + 1.0*3600*i;});},
    );
  }
}

