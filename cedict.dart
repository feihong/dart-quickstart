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

Future main() async {
  var file = await getFile();
  var inputStream = file.openRead();
  var lines = inputStream
    .transform(new GZipCodec().decoder)
    .transform(new Utf8Decoder())
    .transform(new LineSplitter());

  await for (var line in lines) {
    print(line);
  }
}
