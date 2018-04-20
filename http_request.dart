import 'dart:io';
import 'dart:async';
import 'dart:convert';

const url = 'http://ipecho.net/plain';

Future main() async {
  // Using the standard library:
  HttpClientRequest req = await HttpClient().getUrl(Uri.parse(url));
  HttpClientResponse res = await req.close();
  await res.transform(utf8.decoder).forEach(print);
}
