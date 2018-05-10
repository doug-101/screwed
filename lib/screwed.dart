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
  var metric = false;
  if (text.endsWith('"')) {
    text = text.substring(0, text.length - 1).trim();
  } else if (text.endsWith('in')) {
    text = text.substring(0, text.length - 2).trim();
  } else if (text.endsWith('mm')) {
    text = text.substring(0, text.length - 2).trim();
    metric = true;
  }
  var dia = double.tryParse(text);
  if (dia != null && dia > 0) {
    var matchedDrills = englishDrills.approxMatch(dia, 2);
    if (matchedDrills.drills.isNotEmpty) {
      return matchedDrills.drills.join('<br>\n');
    }
  }
  return 'Nothing found';
}
