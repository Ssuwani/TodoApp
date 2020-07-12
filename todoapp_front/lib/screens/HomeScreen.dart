import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  List _todo = [
    {"name": "nothing", "done": false}
  ];

  void _load() async {
    String url = 'http://192.168.0.8:5000/load';
    List todoList;
    try {
      var response = await http.get(url);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        print("서버와 통신이 끊겼습니다");
      }
      todoList = json.decode(utf8.decode(response.bodyBytes));
    } catch (e) {
      todoList = [
        {"name": "서버와 통신이 끊겼습니다."}
      ];
    } finally {
      setState(() {
        _todo = todoList;
      });
    }
  }

  void _add(String text) async {
    String url = 'http://192.168.0.8:5000/add';
    Map<String, String> headers = {"Content-type": "application/json"};
    String data = text;
    var response = await http.post(url, headers: headers, body: data);
    List todoList = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      _todo = todoList;
    });
  }

  void _doneOrNot(int index) async {
    String url = 'http://192.168.0.8:5000/doneOrNot';
    Map<String, String> headers = {"Content-type": "application/json"};
    String data = index.toString();
    var response = await http.post(url, headers: headers, body: data);
    List todoList = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      _todo = todoList;
    });
  }

  void _remove(int index) async {
    print("HI");
    String url = 'http://192.168.0.8:5000/remove';
    Map<String, String> headers = {"Content-type": "application/json"};
    String data = index.toString();
    var response = await http.post(url, headers: headers, body: data);
    List todoList = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      _todo = todoList;
    });
  }

  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo")),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Todo',
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => myController.text == ''
                        ? print("nothing")
                        : _add(myController.text),
                    child: Text("ADD"),
                  )
                ],
              )),
          Container(
            margin: EdgeInsets.all(20),
            child: Center(
                child: Text("Todo List", style: TextStyle(fontSize: 32))),
          ),
          Container(
            child: Expanded(
              child: new ListView.builder(
                itemCount: _todo.length,
                itemBuilder: (context, index) {
                  bool value =
                      "${_todo[index]['done']}" == 'true' ? true : false;
                  return CheckboxListTile(
                      value: value,
                      onChanged: (bool value) => _doneOrNot(index),
                      title: Text("${_todo[index]["name"]}"));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
