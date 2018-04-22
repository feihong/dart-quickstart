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
    var bytes =  await http.readBytes(url);
    await file.writeAsBytes(bytes);
    return file;
  }
}

RegExp lineExp = new RegExp(r'([^\s]+) ([^\s]+) \[(.+?)\] /(.+)/');

processLine(String line) {
  Match match = lineExp.firstMatch(line);
  if (match != null) {
    print(match.groups([1,2,3,4]));
  }
  return line;
}

Future main() async {
  var lines = (await getFile())
    .openRead()
    .transform(new GZipCodec().decoder)
    .transform(new Utf8Decoder())
    .transform(new LineSplitter())
    .map(processLine)
    .forEach((line) => print(line));

  // await for (var line in lines) {
  //   print(line);
  // }
}
