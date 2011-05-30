/*============================================================================
  Copyright(c) 2010 Mario L Gutierrez <mario@mgutz.com>
  MIT Licensed

  AUTO-GENERATED. DO NOT EDIT.
============================================================================*/
// Original file: src/lib/settings.coffee
var Settings, assert, merger;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
assert = require('assert');
merger = require('../support/merger');
Settings = function(pathOrModule, options) {
  this.options = options != null ? options : {};
  if (typeof pathOrModule === 'string') {
    this.path = pathOrModule;
    this.environments = require(pathOrModule);
  } else {
    this.environments = pathOrModule;
  }
  if (this.options.globalKey != null) {
    this._settings = this.getEnvironment();
    global.__defineGetter__(this.options.globalKey, __bind(function() {
      return this._settings;
    }, this));
  }
  return this;
};
Settings.prototype.getEnvironment = function(environ) {
  var common, result;
  this.env = this.environments.forceEnv || environ || process.env.NODE_ENV || 'common';
  assert.ok(this.environments.common, 'Environment common not found in: ' + this.path);
  assert.ok(this.environments[this.env], 'Environment `' + this.env + '` not found in: ' + this.path);
  if (this.options.defaults != null) {
    common = merger.cloneextend(this.options.defaults, this.environments.common);
  } else {
    common = merger.clone(this.environments.common);
  }
  if (this.env === 'common') {
    result = common;
  } else {
    result = merger.extend(common, this.environments[this.env]);
  }
  if (this.options.globalKey != null) {
    this._settings = result;
  }
  return result;
};
module.exports = Settings;
