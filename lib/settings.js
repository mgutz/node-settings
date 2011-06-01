/*============================================================================
  Copyright(c) 2010 Mario L Gutierrez <mario@mgutz.com>
  MIT Licensed

  AUTO-GENERATED. DO NOT EDIT.
============================================================================*/
// Original file: src/lib/settings.coffee
var Settings, assert, coffee, merger;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
assert = require('assert');
merger = require('../support/merger');
coffee = require('coffee-script');
Settings = function(pathOrModule, options) {
  this.options = options != null ? options : {};
  if (typeof pathOrModule === 'string') {
    this.path = pathOrModule;
  }
  this.environments = Settings.loadModule(pathOrModule);
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
  result.override = Settings.override;
  return result;
};
Settings.loadModule = function(pathOrModule) {
  if (typeof pathOrModule === 'string') {
    return require(pathOrModule);
  } else {
    return pathOrModule;
  }
};
Settings.override = function(pathOrModule) {
  var mod;
  mod = Settings.loadModule(pathOrModule);
  if (mod.common != null) {
    mod = new Settings(mod).getEnvironment();
  }
  merger.extend(this, mod);
  return this;
};
module.exports = Settings;
