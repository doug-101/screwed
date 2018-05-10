import 'dart:html';
import 'package:screwed/screwed.dart';

InputElement searchBox;
Element outputElem;

void main() {
  outputElem = querySelector('#output');
  outputElem.text = 'Loaded ${drillCount()} drills';
  searchBox = querySelector('#search-box');
  searchBox.onKeyPress.listen(handleKeyPress);
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
