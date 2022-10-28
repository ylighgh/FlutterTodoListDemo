import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'http/func.dart';
import 'screen/addTodoScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _data = [];
  int _dataSize = 0;
  String _date = "";
  String _appTitle = "";

  Future<void> _getTodayToDoList(String date) async {
    var url = "http://localhost:9999/todo?Action=GetToDoWorkList&Time=$date";
    final res = await http.get(Uri.parse(url));
    final data = await json.decode(res.body);
    setState(() {
      _data = data["ApiData"]["Works"];
      _dataSize = data["ApiData"]["Size"];
    });
  }

  Future<void> _changePage(DateTime dateToday) async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: dateToday,
        firstDate: DateTime(2022),
        lastDate: DateTime(2023));
    if (newDate == null) {
      return;
    }
    setState(() {
      _date = newDate.toString().substring(0, 10);
      _appTitle = _date;
      _getTodayToDoList(_date);
    });
  }

  @override
  void initState() {
    super.initState();
    DateTime dateToday = DateTime.now();
    _date = dateToday.toString().substring(0, 10);
    _getTodayToDoList(_date);
    _appTitle = _date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            onPressed: () => _changePage(DateTime.now()),
          )
        ],
        title: Text(_appTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () => _getTodayToDoList(_date),
        child: ListView.builder(
          itemCount: _dataSize,
          itemBuilder: (BuildContext context, index) {
            return Card(
                margin: const EdgeInsets.all(5.0),
                child: ListTile(
                  title: Text(_data[index]["WorkName"],
                      style: _data[index]["WorkStatus"] == 0
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey)
                          : const TextStyle()),
                  subtitle: Text(_data[index]["WorkDescription"]),
                  onTap: () async {
                    http.Response response = await changeToDoWorkStatus(
                        _data[index]["Id"], _data[index]["WorkStatus"]);
                    if (response.statusCode == 200) {
                      _getTodayToDoList(_date);
                    }
                  },
                  leading: _data[index]["Status"] == 0
                      ? const Icon(Icons.check_box)
                      : const Icon(Icons.check_box_outline_blank_outlined),
                  onLongPress: () async {
                    http.Response response =
                        await deleteToDoWork(_data[index]["Id"]);
                    if (response.statusCode == 200) {
                      _getTodayToDoList(_date);
                    }
                  },
                ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddToDoRoute()));
        },
        tooltip: '增加一条事情',
        child: const Icon(Icons.add),
      ),
    );
  }
}
