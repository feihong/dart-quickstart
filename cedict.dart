/*
 * Download gzip file containg dictionary entries, filter out the
 * multi-character entries and output a JSON file.
 *
 */
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

List<Map> processLine(String line) {
  Match match = lineExp.firstMatch(line);
  if (match == null) {
    return [];
  } else if (match.group(1).length > 1) {
    return [];
  } else {
    var simp = match.group(1),
        trad = match.group(2),
        pinyin = match.group(3).toLowerCase(),
        gloss = match.group(4),
        result = [{'hanzi': simp, 'pinyin': pinyin, 'gloss': gloss}];

    if (simp != trad) {
      result.add({'hanzi': trad, 'pinyin': pinyin, 'gloss': gloss});
    }
    return result;
  }
}

Future main() async {
  var stream = (await getFile())
    .openRead()
    .transform(new GZipCodec().decoder)
    .transform(new Utf8Decoder())
    .transform(new LineSplitter())
    .expand(processLine);

  var items = await stream.toList();
  // for (var item in items) {
  //   print(item);
  // }

  await new File('hanzi.json').writeAsString(new JsonEncoder().convert(items));
  print('Wrote ${items.length} items to hanzi.json');
}
