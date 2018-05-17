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
    var inchDia = isMetric ? (diameter / 0.00254).round() / 10000 : diameter;
    var matchedDrills = englishDrills.approxMatch(inchDia, 4);
    matchedDrills.combine(metricDrills.approxMatch(inchDia, 4));
    matchedDrills = matchedDrills.approxMatch(inchDia, 4);
    results = '<h1>Drills</h1>\n';
    results += matchedDrills.toTable(isMetric, inchDia);

    var matchedThreads = englishThreads.approxMatch(inchDia, true);
    var englishResults = '\n<h1>Unified Threads</h1>\n';
    englishResults += matchedThreads.toTable(inchDia);

    var mmDia = isMetric ? diameter : (diameter * 2540).round() / 100;
    matchedThreads = metricThreads.approxMatch(mmDia, true);
    var metricResults = '\n<h1>Metric Threads</h1>\n';
    metricResults += matchedThreads.toTable(mmDia);

    if (isMetric) {
      results += metricResults + englishResults;
    } else {
      results += englishResults + metricResults;
    }
    return results;
  }
  return 'Nothing found';
}
