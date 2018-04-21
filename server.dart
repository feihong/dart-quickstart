import 'dart:io';
import 'dart:async';
import 'dart:math';

var rand = Random();

getRandomHanzi() {
  const start = 0x4e00, end = 0x9fff;
  const count = end - start + 1;
  var n = rand.nextInt(count) + start;
  return String.fromCharCode(n);
}

Future main(List<String> arguments) async {
  var port = 8000;
  if (arguments.length > 0) {
    port = int.parse(arguments[0]);
  }
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port);
  print('Listening on localhost: ${server.port}');

  await for (HttpRequest request in server) {
    var hanzi = getRandomHanzi();

    request.response.headers.contentType =
      ContentType('text', 'html', charset: 'utf-8');

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
