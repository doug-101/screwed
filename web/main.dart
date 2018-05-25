import 'dart:html';
import 'package:screwed/screwed.dart' as screwed;

InputElement searchBox;
Element outputElem;
InputElement englishBox;
InputElement metricBox;
InputElement uncommonBox;
var previousResults = '';

void main() {
  outputElem = querySelector('#output');
  outputElem.text = 'Ready...';
  searchBox = querySelector('#search-box');
  searchBox.onKeyPress.listen(handleKeyPress);
  searchBox.focus();
  window.onClick.listen(handleClick);
  englishBox = querySelector('#english-only');
  metricBox = querySelector('#metric-only');
  uncommonBox = querySelector('#add-uncommon');
  englishBox.onClick.listen((MouseEvent event) {
    InputElement checkBox = event.target;
    if (checkBox.checked) metricBox.checked = false;
  });
  metricBox.onClick.listen((MouseEvent event) {
    InputElement checkBox = event.target;
    if (checkBox.checked) englishBox.checked = false;
  });
}

void handleKeyPress(KeyboardEvent e) {
  if (e.which == 13) {  // Search on enter key.
    var searchText = searchBox.value.trim();
    if (searchText.isNotEmpty) {
      screwed.isEnglishOnly = englishBox.checked;
      screwed.isMetricOnly = metricBox.checked;
      screwed.isCommonOnly = !uncommonBox.checked;
      previousResults = screwed.textSearch(searchText);
      outputElem.innerHtml = previousResults;
    }
    e.preventDefault();
  }
}

void handleClick(MouseEvent event) {
  if (event.target is Element && event.target != null) {
    Element target = event.target;
    if (target.className == 'clickable' ||
        (target.parent != null && target.parent.className == 'clickable')) {
      outputElem.innerHtml = screwed.threadDetails(target.text);
    } else if (target.id == 'back_link') {
      outputElem.innerHtml = previousResults;
    }
  }
}
