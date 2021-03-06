// Generated by CoffeeScript 1.6.2
var deepExtend, is_plain_obj;

is_plain_obj = require('./is_plain_obj');

deepExtend = function(a, b) {
  var name, nowValue, part, target, value, _i, _len, _ref;

  target = {};
  _ref = [a, b];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    part = _ref[_i];
    for (name in part) {
      value = part[name];
      nowValue = target[name];
      if (nowValue === value) {

      } else if (Array.isArray(value) && Array.isArray(nowValue)) {
        target[name] = nowValue.concat(value);
      } else if (is_plain_obj(value) && is_plain_obj(nowValue)) {
        target[name] = deepExtend(nowValue, value);
      } else if ((value != null) || (nowValue === void 0)) {
        target[name] = value;
      }
    }
  }
  return target;
};

module.exports = deepExtend;
