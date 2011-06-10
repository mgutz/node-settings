/*============================================================================
  Copyright(c) 2010 Mario L Gutierrez <mario@mgutz.com>
  MIT Licensed

  AUTO-GENERATED. DO NOT EDIT.
============================================================================*/
// Original file: src/test/coffee.test.coffee
var Settings, assert, _settings;
Settings = require('../lib');
assert = require('assert');
_settings = new Settings(__dirname + '/../src/test/config/environment');
module.exports = {
  "should get specific environment": function() {
    var settings;
    settings = _settings.getEnvironment('development');
    assert.equal('server_dev', settings.storage.database);
    settings = _settings.getEnvironment();
    assert.equal('server_dev', settings.storage.database);
    settings = _settings.getEnvironment('test');
    assert.equal('server_test', settings.storage.database);
    settings = _settings.getEnvironment('production');
    return assert.equal('server_production', settings.storage.database);
  }
};
