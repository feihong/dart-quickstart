import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uri/uri.dart';

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
  final template = UriTemplate(baseUrl + r'{?app_token,where}');
  // We need to replace here because UriTemplate is not able to accept param
  // names that start with $.
  var url = template.expand({"app_token": appToken, "where": query})
    .replaceFirst('app_token=', r'$$app_token=')
    .replaceFirst('where=', r'$where=');
  return url;
}

Future main() async {
  var url = buildUrl();
  print(url);
  String data = await http.read(url);
  print(data);
}
