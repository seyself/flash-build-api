// Generated by CoffeeScript 1.6.2
var DOMParser, XMLSerializer, fs, _ref;

_ref = require('xmldom'), DOMParser = _ref.DOMParser, XMLSerializer = _ref.XMLSerializer;

fs = require('fs');

module.exports = function(data, inputFile, outputFile, mainFile, version, id, onComplete) {
  var child, doc, dom, e, parser, subchild, _i, _j, _len, _len1, _ref1, _ref2;

  try {
    parser = new DOMParser();
    dom = parser.parseFromString(data);
    doc = dom.documentElement;
    _ref1 = doc.childNodes;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      child = _ref1[_i];
      switch (child.nodeName) {
        case "initialWindow":
          _ref2 = child.childNodes;
          for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
            subchild = _ref2[_j];
            if (subchild.nodeName === "content") {
              subchild.firstChild.data = mainFile;
            }
          }
          break;
        case "versionNumber":
          if (version != null) {
            child.firstChild.data = version;
          }
          break;
        case "id":
          if (id != null) {
            child.firstChild.data = id;
          } else {
            id = child.firstChild.data;
          }
      }
    }
    console.info("Writing changes on file " + inputFile + " to " + outputFile);
    return fs.writeFile(outputFile, new XMLSerializer().serializeToString(doc), function(error, result) {
      if (error) {
        return onComplete(error);
      } else {
        return onComplete(null, id);
      }
    });
  } catch (_error) {
    e = _error;
    console.error(e.stack);
    return onComplete(e);
  }
};