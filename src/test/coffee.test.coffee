Settings = require('../lib')
assert   = require('assert')

# read the original coffee file
_settings = new Settings(__dirname + '/../src/test/config/environment')

# Coffee compiles to javascript. A single test is enough here.
# Exhaustive tests are performed against javascript configuration files.
module.exports =
  "should get specific environment": ->
    settings = _settings.getEnvironment('development')
    assert.equal 'server_dev', settings.storage.database

    # default should be 'common'
    settings = _settings.getEnvironment()
    assert.equal 'server_dev', settings.storage.database

    settings = _settings.getEnvironment('test')
    assert.equal 'server_test', settings.storage.database

    settings = _settings.getEnvironment('production')
    assert.equal 'server_production', settings.storage.database
