import 'dart:io';
import 'dart:async';
import 'dart:math';

var rand = new Random();

getRandomHanzi() {
  const start = 0x4e00, end = 0x9fff;
  const count = end - start + 1;

  var n = rand.nextInt(count) + start;
  return new String.fromCharCode(n);
}

Future main() async {
  Map<string, string> env = Platform.environment;
  int port = env['PORT'] == null ? 8000 : int.parse(env['PORT']);
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port);
  print('Listening on localhost: ${server.port}');

  await for (HttpRequest request in server) {
    var hanzi = getRandomHanzi();

    request.response.headers.contentType =
      new ContentType('text', 'html', charset: 'utf-8');

    request.response
      ..write('<h1 style="font-size: 5rem">$hanzi</h1>')
      ..close();
  }
}
