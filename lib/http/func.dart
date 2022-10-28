import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> addToDoWork(
    String name, String description, String time) {
  return http.get(
    Uri.parse('http://localhost:9999/todo?Action=AddToDoWork&WorkName=$name&WorkDescription=$description&Time=$time'),
  );
}

Future<http.Response> changeToDoWorkStatus(int id, int status) {
  var url = "";
  if (status == 1) {
    url = "http://localhost:9999/todo?Action=ChangeToDoWorkStatus&Id=$id&Status=0";
  } else {
    url = "http://localhost:9999/todo?Action=ChangeToDoWorkStatus&Id=$id&Status=1";
  }
  return http.get(
    Uri.parse(url),
  );
}

Future<http.Response> deleteToDoWork(int id) {
  var url = "http://localhost:9999/todo?Action=DeleteToDoWork&Id=$id";
  return http.get(
    Uri.parse(url),
  );
}
