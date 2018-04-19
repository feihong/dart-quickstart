import 'dart:io';
import 'dart:async';

Future main() async {
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8000);
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    request.response.headers.contentType =
      new ContentType("text", "html", charset: "utf-8");

    request.response
      ..write('<h1>你好世界！</h1>')
      ..close();
  }
}
