import 'dart:html';
import 'package:screwed/screwed.dart';

InputElement searchBox;
Element outputElem;

void main() {
  outputElem = querySelector('#output');
  outputElem.text = 'Ready...';
  searchBox = querySelector('#search-box');
  searchBox.onKeyPress.listen(handleKeyPress);
  searchBox.focus();
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
  if (event.target is Element && event.target != null) {
    Element target = event.target;
    if (target.className == 'clickable' ||
        (target.parent != null && target.parent.className == 'clickable')) {
      outputElem.innerHtml = threadDetails(target.text);
    } else if (target.id == 'back_link') {
      outputElem.innerHtml = previousResults;
    }
  }
}
