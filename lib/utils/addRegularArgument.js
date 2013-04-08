// Generated by CoffeeScript 1.6.2
var allInQuotes, inQuotes;

inQuotes = require("./inQuotes");

allInQuotes = require("./allInQuotes");

module.exports = function(name, value, separator) {
  var arg;

  arg = "-" + name + separator;
  if (typeof value === "string") {
    if (!isNaN(parseInt(value))) {
      return arg += value;
    } else if (value.toLowerCase() === "true") {
      return arg += "true";
    } else if (value.toLowerCase() === "false") {
      return arg += "false";
    } else {
      return arg += inQuotes(value);
    }
  } else {
    return arg += allInQuotes(value).join(",");
  }
};