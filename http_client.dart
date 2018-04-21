import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const appToken = '';
const baseUrl = 'https://data.cityofchicago.org/resource/xqx5-8hwx.json';

String buildUrl() {
  final startDate = new DateTime.now().subtract(new Duration(days: 90));
  final startDateStr = new DateFormat("y-M-d").format(startDate) + "T00:00:00.000";
  final query = """
  application_type = 'ISSUE' AND
  license_status = 'AAI' AND
  license_start_date >= '$startDateStr' AND
  within_circle(location, 41.972116, -87.689468, 1600)
  """.replaceAll('\n', '');

  // Normally we could use UriTemplate to build the query string, but that won't
  // work for params starting with $.
  final queryString = {r'$$app_token': appToken, r'$where': query}
    .entries
    .fold([], (acc, entry) =>
      acc..add(entry.key + '=' + Uri.encodeComponent(entry.value)))
    .join('&');
  return baseUrl + '?' + queryString;
}

Future main() async {
  var url = buildUrl();
  print(url);
  String data = await http.read(url);
  print(data);
}
