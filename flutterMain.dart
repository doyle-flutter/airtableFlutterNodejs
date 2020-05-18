import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 8. design 중복

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: ListDesignPage(),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
      theme: ThemeData(
        accentColor: Colors.white10,
      ),
    )
  );
}

class ListDesignPage extends StatefulWidget {
  @override
  _ListDesignPageState createState() => _ListDesignPageState();
}

class _ListDesignPageState extends State<ListDesignPage> with SingleTickerProviderStateMixin{

  List<dynamic> data;
  int currentIndex = 0;

  Animation<Color> animation;
  AnimationController controller;

  Future<List> fetch() async{
    var res = await http.get('http://127.0.0.1:3000');
    final List _result = json.decode(res.body);
    return data = _result;
  }

  @override
  void initState() {
    Future.microtask(() async{
      controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 300));
      animation = new ColorTween(begin: Colors.red, end: Colors.white)
        .animate(controller)
          ..addListener(() => setState(() {}));
      return;
    }).then((_) async{
      await fetch();
      setState(() {});
      controller.forward();
      return;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.data == null || this.data.isEmpty
      ? Center(child: Text("Load..."))
      : Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 200.0,
            left: 60.0,
            right: 60.0,
            bottom: 170.0,
            child: Container(
              color: Colors.grey[300],
            ),
          ),
          Positioned(
            top: 200.0,
            left: 50.0,
            right: 50.0,
            bottom: 180.0,
            child: Container(
              color: Colors.grey[400],
            ),
          ),
          Positioned(
            top: 200.0,
            left: 40.0,
            right: 40.0,
            bottom: 190.0,
            child: Container(
              color: Colors.grey[600],
            ),
          ),
          Positioned(
            top: 200.0,
            left: 30.0,
            right: 30.0,
            bottom: 200.0,
            child: GestureDetector(
              onTap: () async{
                controller.reset();
                await controller.forward();
                if(this.currentIndex < data.length-1){
                  setState(() {
                    currentIndex += 1;
                  });
                  return;
                }
                else{
                  setState(() {
                    currentIndex = 0;
                  });
                  return;
                }
              },
              child: Container(
                color: animation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      data[currentIndex]['fields']['Name'].toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      data[currentIndex]['fields']['Notes'].toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50.0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.red[400]
                ),
                alignment: Alignment.center,
                child: Text(
                  "생활코딩 - AirTable",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
