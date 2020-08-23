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
  List<String> citys = [];
  List<double> jetlag = [];

  @override
  void initialize(FlutterActorArtboard artboard) {
    _numbers = artboard.getAnimation("number_blinks_as60s");
    _hour_ptr = artboard.getNode("Hour");
    _min_ptr = artboard.getNode("Minute");
    var n = new DateTime.now();
    now_seconds = 1.0 * (n.hour * 3600 + n.minute * 60 + n.second);
    citys =
    ["阿布扎比", "阿姆斯特丹", "爱丁堡", "巴黎", "柏林", "北京", "波士顿", "布达佩斯", "布鲁塞尔", "德黑兰",
        "迪拜", "东京", "多伦多", "华盛顿", "惠灵顿", "开普敦", "伦敦", "曼谷", "墨尔本", "新德里"];
    jetlag = [-4.0, -6.0, -7.0, -6.0, -6.0, 0.0, -12.0, -6.0, -6.0, -4.5,
      -4.0, 1.0, -12.0, -12.0, 4.0, -6.0, -7.0, -1.0, 2.0, -2.5];
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
      itemCount: 21,
      itemBuilder: (context, i) {
        if (i==0) {
          return DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Center(
              child: SizedBox(
                width: 200.0,
                height: 200.0,
                child: CircleAvatar(
                  child: Text('时区选择'),
                ),
              ),
            ),
          );
        }
        else
          return _buildRow(citys[i-1], jetlag[i-1], context);
      },
    );
  }

  Widget _buildRow(String city, double jlag, BuildContext context) {
    return new ListTile(
      title: new Text(
        city,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      onTap: () {
        var now = new DateTime.now();
        now_seconds = 1.0 * (now.hour * 3600 + now.minute * 60 + now.second);
        setState(() { now_seconds = now_seconds + 3600*jlag;});
        Navigator.pop(context);
        },
    );
  }
}

