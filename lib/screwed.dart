import 'package:screwed/src/drill_list.dart';
import 'package:screwed/src/thread_list.dart';

var englishDrills = DrillData.load(false);
var metricDrills = DrillData.load(true);
var englishThreads = ThreadData.load(false);
var metricThreads = ThreadData.load(true);
var isEnglishOnly = false;
var isMetricOnly = false;
var isCommonOnly = true;

String textSearch(String text) {
  var isMetric = isMetricOnly;
  if (text.endsWith('"')) {
    text = text.substring(0, text.length - 1).trim();
    isMetric = false;
  } else if (text.endsWith('in')) {
    text = text.substring(0, text.length - 2).trim();
    isMetric = false;
  } else if (text.endsWith('mm')) {
    text = text.substring(0, text.length - 2).trim();
    isMetric = true;
  }
  var diameter = double.tryParse(text);
  if (diameter != null && diameter > 0) {
    var results = '';
    var inchDia = isMetric ? (diameter / 0.00254).round() / 10000 : diameter;
    DrillData matchedDrills;
    if (isEnglishOnly) {
      matchedDrills = englishDrills.approxMatch(inchDia, 4, false);
    } else if (isMetricOnly) {
      matchedDrills = metricDrills.approxMatch(inchDia, 4, isCommonOnly);
    } else {
      matchedDrills = englishDrills.approxMatch(inchDia, 4, false);
      matchedDrills.combine(metricDrills.approxMatch(inchDia, 4,
                                                     isCommonOnly));
      matchedDrills = matchedDrills.approxMatch(inchDia, 4, false);
    }
    results = '<h1>Drills</h1>\n';
    results += matchedDrills.toTable(isMetric, inchDia);

    var englishResults = '';
    ThreadData matchedThreads;
    if (!isMetricOnly) {
      matchedThreads = englishThreads.approxMatch(inchDia, isCommonOnly);
      englishResults = '\n<h1>Unified Threads</h1>\n';
      englishResults += matchedThreads.toTable(inchDia);
    }

    var metricResults = '';
    if (!isEnglishOnly) {
      var mmDia = isMetric ? diameter : (diameter * 2540).round() / 100;
      matchedThreads = metricThreads.approxMatch(mmDia, isCommonOnly);
      metricResults = '\n<h1>Metric Threads</h1>\n';
      metricResults += matchedThreads.toTable(mmDia);
    }

    if (isMetric) {
      results += metricResults + englishResults;
    } else {
      results += englishResults + metricResults;
    }
    return results;
  }
  return 'Nothing found';
}

String threadDetails(String name) {
  String details;
  if (name.startsWith('M')) {
    details = metricThreads.nameMatch(name).details();
  } else {
    details = englishThreads.nameMatch(name).details();
  }
  details += '\n<p id="back_link">Return to list</p>';
  return details;
}
