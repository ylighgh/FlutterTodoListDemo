import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../http/func.dart';
import 'package:http/http.dart' as http;

class AddToDoRoute extends StatelessWidget {
  const AddToDoRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加待办事项"),
      ),
      body: const Center(child: _AddTodoRoute()),
    );
  }
}

class _AddTodoRoute extends StatefulWidget {
  const _AddTodoRoute();

  @override
  _AddTodoRouteState createState() => _AddTodoRouteState();
}

class _AddTodoRouteState extends State<_AddTodoRoute> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _caleController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DateTime dateToday = DateTime.now();

    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "事情名",
              hintText: "准备做什么",
              icon: Icon(Icons.edit),
            ),
            // 校验内容
            validator: (v) {
              return v!.trim().isNotEmpty ? null : "请填写";
            },
          ),
          TextFormField(
            controller: _desController,
            decoration: const InputDecoration(
              labelText: "描述",
              hintText: "添加描述",
              icon: Icon(Icons.description),
            ),
          ),
          TextFormField(
            controller: _caleController,
            decoration: const InputDecoration(
              labelText: "日期",
              icon: Icon(Icons.calendar_month),
            ),
            onTap: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: dateToday,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2023));
              if (newDate == null) {
                return;
              }
              setState(() =>
                  _caleController.text = newDate.toString().substring(0, 10));
            },
          ),
          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("提交"),
                    ),
                    onPressed: () async {
                      if ((_formKey.currentState as FormState).validate()) {
                        http.Response response = await addToDoWork(
                            _nameController.text,
                            _desController.text,
                            _caleController.text);
                        if (kDebugMode) {
                          print(response.body);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
