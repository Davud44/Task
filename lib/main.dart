import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        unselectedWidgetColor: Color(0xFF0176E1),
          disabledColor:  Color(0xFF0176E1)
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFffffff),
      body: Padding(
        padding: EdgeInsets.all(2),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(),
              Container(
                  margin: EdgeInsets.only(top: 20, left: 10),
                  child: Text(
                    "Tasks",
                    style: TextStyle(
                        color: Color(0xFF333232),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  )),
              Tasks()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFffffff),
        child: Icon(
          Icons.add,
          color: Color(0xFF0176E1),
        ),
      ),
    ));
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/menu.png'),
          Text(
            "task.",
            style: TextStyle(
                color: Color(0xFF0176E1),
                fontSize: 22,
                fontWeight: FontWeight.w900),
          ),
          Container(width: 0, height: 0)
        ],
      ),
    );
  }
}

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Future<List<TaskModel>> _tasks;
  Future<List<TaskModel>> getTasks() async {
    http.Response response = await http.get(
        'https://cdn.fonibo.com/challenges/tasks.json' );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body) ;

      List<TaskModel> tasks = new List();

      for (int i = 0; i < body.length; i++) {
        tasks.add(new TaskModel(body[i]['id'], body[i]['title'], body[i]['createdAt']));
      }

      return tasks;
    } else {
      throw "cant get";
    }
  }

  @override
  void initState() {
    super.initState();
    _tasks = getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _tasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TaskModel> data = snapshot.data;
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var colors = [0xFFFFDEDE , 0xFFB1F8C1 , 0xFFFEDEFF];
                  final DateTime now = DateTime.parse(data[index].createdAt);
                  final DateFormat formatter = DateFormat('yyyy-MM-dd HH-mm');
                  final String formatted = formatter.format(now);
                  return Task( id :data[index].id,  title: data[index].title, createdAt :formatted , color: colors[index%3],);
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Task extends StatelessWidget {
  int id;
  String title;
  String createdAt;
  int color;

  Task({this.id ,this.title, this.createdAt , this.color});



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 66,
      child: Row(
        children: [
          Container(
            width: 9,
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(color)
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width-50,
            height: 66,
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Color(0xFF333232  ),fontSize: 16 , fontWeight: FontWeight.w500),
                    ),
                    Text(
                      createdAt,
                      style: TextStyle(color: Color(0xFF4E4E4E  ),fontSize: 12  ),
                    )
                  ],
                ),
                Radio(
                  value: id,
                  groupValue: 44,
                  activeColor: Color(0xFF0176E1),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
