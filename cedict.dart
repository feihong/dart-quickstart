import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const url = 'https://www.mdbg.net/chinese/export/cedict/cedict_1_0_ts_utf-8_mdbg.txt.gz';

Future<File> getFile() async {
  var file = new File('cedict.txt.gz');

  if (await file.exists()) {
    return file;
  } else {
    print('Downloading file...');
    var bytes = await http.readBytes(url);
    await file.writeAsBytes(bytes);
    return file;
  }
}

RegExp lineExp = new RegExp(r'([^\s]+) ([^\s]+) \[(.+?)\] /(.+)/');

processLine(String line) {
  Match match = lineExp.firstMatch(line);
  if (match == null) {
    return null;
  } else {
    return {
      'simplified': match.group(1),
      'traditional': match.group(2),
      'pinyin': match.group(3).toLowerCase(),
      'gloss': match.group(4),
    };
  }
}

Future main() async {
  var items = (await getFile())
    .openRead()
    .transform(new GZipCodec().decoder)
    .transform(new Utf8Decoder())
    .transform(new LineSplitter())
    .map(processLine)
    .where((item) => item != null && item['simplified'].length == 1)
    .forEach((item) => print(item));

  // await for (var line in lines) {
  //   print(line);
  // }
}
