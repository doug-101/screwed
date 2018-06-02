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
  text = text.toLowerCase();
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
    return diameterSearch(diameter, isMetric);
  }
  var fractionRegExp = RegExp(r'(?:(\d+)\s*-?)?\s*(\d+)\s*/\s*(\d+)\s*$');
  var fractionMatch = fractionRegExp.firstMatch(text);
  if (fractionMatch != null) {
    diameter = fractionMatch[1] != null ? double.parse(fractionMatch[1]) : 0;
    diameter += double.parse(fractionMatch[2]) /
                double.parse(fractionMatch[3]);
    return diameterSearch(diameter, isMetric);
  }
  if (text.contains('-')) {
    var englishThread = englishThreads.nameMatch(text);
    if (englishThread != null) {
      return englishThread.details();
    }
  }
  if (text.contains('x')) {
    var metricThread = metricThreads.nameMatch(text);
    if (metricThread != null) {
      return metricThread.details();
    }
  }
  ThreadData matchedThreads;
  if (text.startsWith('m')) {
    matchedThreads = metricThreads.diaNameMatch(text, isCommonOnly);
    if (matchedThreads.length == 1) {
      return matchedThreads.threads[0].details();
    } else if (matchedThreads.length > 1) {
      return '\n<h1>Metric Threads</h1>\n' + matchedThreads.toTable(0.0);
    }
  }
  var results = '';
  if (text.startsWith('#')) {
    var matchedDrill = englishDrills.nameMatch(text);
    if (matchedDrill != null) {
      results = '<h1>Drills</h1>\n';
      results += DrillData([matchedDrill]).toTable(false, 0.0);
    }
    matchedThreads = englishThreads.diaNameMatch(text, isCommonOnly);
    if (matchedThreads.length > 0) {
      results +=  '\n<h1>Unified Threads</h1>\n';
      results += matchedThreads.toTable(0.0);
    }
    if (results.isNotEmpty) return results;
  }
  if (text.length == 1) {
    var namedDrill = englishDrills.nameMatch(text.toUpperCase());
    if (namedDrill != null) {
      results = '<h1>Drills</h1>\n';
      results += DrillData([namedDrill]).toTable(false, 0.0);
      return results;
    }
  }
  return 'Nothing found';
}

String diameterSearch(double diameter, bool isMetric) {
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

String threadDetails(String name) {
  name = name.toLowerCase();
  String details;
  if (name.startsWith('m')) {
    details = metricThreads.nameMatch(name).details();
  } else {
    details = englishThreads.nameMatch(name).details();
  }
  details += '\n<p id="back_link">Return to list</p>';
  return details;
}

String helpText() {
  var text = '<br>'
             'Enter a number into the search box to list drills and<br>'
             'threads with close to that diameter.  The number can be<br>'
             'followed by a unit ("in" or a double quote for inches,<br>'
             '"mm" for millimeters).  If no unit is entered, it defaults<br>'
             'to inches (unless the "Metric Only" box is checked).<br>'
             'Fractional diameters can also be entered.<br><br>'
             'Search entries can also be more specific.  Enter "#6" to<br>'
             'find a numbered drill or thread size.  Or "B" to find<br>'
             'a lettered drill size.  Or enter ".25-20" or "4x0.7"<br>'
             'to show a particular thread size.<br><br>'
             'The blue names in the thread list can be clicked for more<br>'
             'details for that thread size.  Note that all of the thread<br>'
             'dimensions given are nominals.<br><br>'
             'The "Include Uncommon Sizes" box can be checked to<br>'
             'show less common drill and thread sizes.';
  return text;
}
