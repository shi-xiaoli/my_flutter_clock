import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//key = a17d10bd349e432d99228b4331ed7628
//实况天气  https://devapi.heweather.net/v7/weather/now?{请求参数}
//城市信息  https://geoapi.heweather.net/v2/city/lookup?{请求参数}
//南京 101190101
class WeatherPage extends StatefulWidget {
  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  //data
  WeatherData weather = WeatherData.empty();
  
  WeatherState() {
    _getWeather();
  }

   _getWeather() async{
    WeatherData data = await _fetchWeather();
    setState((){
      weather = data;
    });
  }

  Future<WeatherData>_fetchWeather() async{
    print("请求网络-----");
    final response = await http.get('https://devapi.heweather.net/v7/weather/now?location=101010100&key=a17d10bd349e432d99228b4331ed7628');
    //final response = await http.get('https://free-api.heweather.com/s6/weather/now?location=广州&key=ebb698e9bb6844199e6fd23cbb9a77c5');
    //if(response.statusCode == 200){
    if(response.statusCode == 200){
      print("请求成功");
      print(response.body);
      return WeatherData.fromJson(json.decode(response.body));
    }else{
      print("请求出错，返回状态码：");
      print(response.statusCode);
      return new WeatherData();
    };
  }

  Widget build(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          new Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 40.0),
            child: new Text(
              "南京",
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            ),
          ),
          new Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 100.0),
            child: new Column(
              children: <Widget>[
                new Text(
                    weather?.tmp,
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 80.0
                    )),
                new Text(
                    weather?.cond,
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 45.0
                    )),
                new Text(
                  weather?.hum,
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 30.0
                  ),
                ),
                new IconButton(
                  color: Colors.lightBlue,
                  icon: Icon(Icons.add_location),
                  onPressed: _getWeather,
                ),
              ],
            ),
          )
        ]
      )

    );
  }
}

class WeatherData{
  String cond; //天气
  String tmp; //温度
  String hum; //湿度

  WeatherData({this.cond, this.tmp, this.hum});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      /*
      cond: json['HeWeather7'][0]['now']['text'],
      tmp: json['HeWeather7'][0]['now']['temp']+"°",
      hum: "湿度  "+json['HeWeather7'][0]['now']['humidity']+"%",
       */
      cond: json['now']['text'],
      tmp: json['now']['temp']+"°",
      hum: "湿度  "+json['now']['humidity']+"%",
    );
  }

  factory WeatherData.empty() {
    return WeatherData(
      cond: "",
      tmp: "",
      hum: "",
    );
  }

}

