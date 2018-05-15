import 'package:screwed/src/drill_list.dart';
import 'package:screwed/src/thread_list.dart';

var englishDrills = DrillData.load(false);
var metricDrills = DrillData.load(true);
var englishThreads = ThreadData.load(false);
var metricThreads = ThreadData.load(true);

int drillCount() {
  return englishDrills.drills.length;
}

String textSearch(String text) {
  var isMetric = false;
  if (text.endsWith('"')) {
    text = text.substring(0, text.length - 1).trim();
  } else if (text.endsWith('in')) {
    text = text.substring(0, text.length - 2).trim();
  } else if (text.endsWith('mm')) {
    text = text.substring(0, text.length - 2).trim();
    isMetric = true;
  }
  var diameter = double.tryParse(text);
  if (diameter != null && diameter > 0) {
    var results = '';
    var inchDia = isMetric ? diameter / 25.4 : diameter;
    var matchedDrills = englishDrills.approxMatch(inchDia, 4);
    matchedDrills.combine(metricDrills.approxMatch(inchDia, 4));
    if (matchedDrills.isNotEmpty) {
      matchedDrills = matchedDrills.approxMatch(inchDia, 4);
      results = '<h1>Drills</h1>\n';
      results += matchedDrills.toTable(isMetric, inchDia);
    }
    var matchedThreads = englishThreads.approxMatch(diameter, true);
    results += '<h1>Threads</h1>\n';
    results += matchedThreads.toTable(diameter);
    return results;
  }
  return 'Nothing found';
}
