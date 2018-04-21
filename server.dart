import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:ini/ini.dart';

var rand = new Random();

String getRandomHanzi() {
  const start = 0x4e00, end = 0x9fff;
  const count = end - start + 1;
  var n = rand.nextInt(count) + start;
  return new String.fromCharCode(n);
}

Future<int> getPort() async {
  var lines = await new File("server.ini").readAsLines();
  var cfg = new Config.fromStrings(lines);
  return int.parse(cfg.get('default', "port"));
}

Future main() async {
  var port = await getPort();
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port);
  print('Listening on localhost: ${server.port}');

  await for (HttpRequest request in server) {
    var hanzi = getRandomHanzi();

    request.response.headers.contentType =
      new ContentType('text', 'html', charset: 'utf-8');

    request.response
      ..write("""<html>
        <head>
          <title>Random Hanzi</title>
        </head>
        <body>
          <div style="font-size: 5rem">$hanzi</div>
        </body>
      </html>""")
      ..close();
  }
}
