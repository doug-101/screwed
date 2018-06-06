// Screwed, a web app for finding drill and thread data.
// Copyright (C) 2018, Douglas W. Bell
//
// This is free software; you can redistribute it and/or modify it under the
// terms of the GNU General Public License, either Version 2 or any later
// version.  This program is distributed in the hope that it will be useful,
// but WITTHOUT ANY WARRANTY.  See the included LICENSE file for details.

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
    searchBox.focus();
  });
  metricBox.onClick.listen((MouseEvent event) {
    InputElement checkBox = event.target;
    if (checkBox.checked) englishBox.checked = false;
    searchBox.focus();
  });
  uncommonBox.onClick.listen((MouseEvent event) {
    searchBox.focus();
  });
  querySelector('#search-button').onClick.listen((MouseEvent event) {
    startSearch();
    searchBox.focus();
  });
}

/// Search for the contents of the search text box.
void startSearch() {
  querySelector('#help_link').hidden = false;
  var searchText = searchBox.value.trim();
  if (searchText.isNotEmpty) {
    screwed.isEnglishOnly = englishBox.checked;
    screwed.isMetricOnly = metricBox.checked;
    screwed.isCommonOnly = !uncommonBox.checked;
    previousResults = screwed.textSearch(searchText);
    outputElem.innerHtml = previousResults;
  }
}

/// Start a search when Enter key is pressed.
void handleKeyPress(KeyboardEvent e) {
  if (e.which == 13) {
    startSearch();
    e.preventDefault();
  }
}

/// Handle clicks on thread detail links and other links.
void handleClick(MouseEvent event) {
  if (event.target is Element && event.target != null) {
    Element target = event.target;
    if (target.className == 'clickable' ||
        (target.parent != null && target.parent.className == 'clickable')) {
      outputElem.innerHtml = screwed.threadDetails(target.text);
    } else if (target.id == 'back_link') {
      outputElem.innerHtml = previousResults;
    } else if (target.id == 'help_link') {
      querySelector('#help_link').hidden = true;
      outputElem.innerHtml = screwed.helpText();
    }
  }
}
