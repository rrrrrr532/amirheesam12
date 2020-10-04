import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';

const links = {
  'confirmed':
      'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv',
  'deaths':
      'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv',
  'recovered':
      'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv'
};

Future fetchRawData(String link) async {
  final request = await HttpClient().getUrl(Uri.parse(link));
  final response = await request.close();
  final data = await response
      .transform(utf8.decoder)
      .transform(new CsvToListConverter(eol: '\n'))
      .toList();
  return Future(() => data);
}

List extractData(List data, String country) {
  List result = [];
  for (var l in data) {
    if (l[1] == country) {
      Map<String, dynamic> res = {};
      for (var i = 0; i < data[0].length; i++) {
        res[data[0][i]] = l[i];
      }
      result.add(res);
    }
  }
  return result;
}

void main() async {
  try {
    final rawDeaths = await fetchRawData(links['deaths']);
    final rawConfirmed = await fetchRawData(links['confirmed']);
    final rawRecovered = await fetchRawData(links['recovered']);

    print(extractData(rawDeaths, 'Iran'));
    print(extractData(rawConfirmed, 'Iran'));
    print(extractData(rawRecovered, 'Iran'));
  } catch (err) {
    print('error: $err');
  }
}
