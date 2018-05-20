import 'dart:html';
import 'package:screwed/screwed.dart';

InputElement searchBox;
Element outputElem;

void main() {
  outputElem = querySelector('#output');
  outputElem.text = 'Loaded ${drillCount()} drills';
  searchBox = querySelector('#search-box');
  searchBox.onKeyPress.listen(handleKeyPress);
  window.onClick.listen(handleClick);
}

void handleKeyPress(KeyboardEvent e) {
  if (e.which == 13) {  // Search on enter key.
    var searchText = searchBox.value.trim();
    if (searchText.isNotEmpty) {
      outputElem.innerHtml = textSearch(searchText);
    }
    e.preventDefault();
  }
}

void handleClick(MouseEvent event) {
  if (event.target is Element) {
    Element target = event.target;
    if ((target != null && target.className == 'clickable') ||
        (target.parent != null && target.parent.className == 'clickable')) {
      outputElem.innerHtml = threadDetails(target.text);
    }
  }
}
