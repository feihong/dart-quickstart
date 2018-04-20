// import 'dart:io';
// import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

const url = 'http://ipecho.net/plain';

Future main() async {
  // Using the standard library:
  // HttpClientRequest req = await HttpClient().getUrl(Uri.parse(url));
  // HttpClientResponse res = await req.close();
  // await res.transform(utf8.decoder).forEach(print);

  String data = await http.read(url);
  print(data);
}
