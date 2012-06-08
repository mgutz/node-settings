{assert} = require("chai")
Settings = require("../lib/settings")

instance = ->
  new Settings(__dirname + "/config/environment")


describe "Settings", ->

  it "should get specific environment", ->
    settings = instance()._obj._useEnvironment('development')
    assert.equal 'server_dev', settings.storage.database

    # default should be 'development'
    settings = instance()._obj._useEnvironment()
    assert.equal 'server_dev', settings.storage.database

    settings = instance()._obj._useEnvironment('test')
    assert.equal 'server_test', settings.storage.database

    settings = instance()._obj._useEnvironment('production')
    assert.equal 'server_production', settings.storage.database


  it "should get value from ancestor if key is not found", ->
    settings = instance()._obj._useEnvironment('test')
    assert.equal 'password', settings.storage.password


  it "should have a forceEnv property to force all settings through an environment", ->
    environments =
      'common':
        foo: 'boo'
      'development':
        foo: 'bar'
      'test':
        foo: 'bah'
      'prod':
        foo: 'baz'
      forceEnv: 'development'

    settings = new Settings(environments)
    set = settings._obj._useEnvironment('development')
    assert.equal 'bar', set.foo

    set = settings._obj._useEnvironment('test')
    assert.equal 'bar', set.foo

    set = settings._obj._useEnvironment('prod')
    assert.equal 'bar', set.foo


  it "should replace array values, not merge them", ->
    environments =
      'common':
        arr: [1, 2, 3]
      'development':
        arr: [4, 5, 6]

    settings = new Settings(environments)._obj._useEnvironment('development')
    assert.deepEqual [4, 5, 6], settings.arr


  it "should do a deep merge", ->
    environments =
      'common': { a: { b: { c: { arr: [1, 2, 3], bah: 'baz' },  bar: 'bar' } } }
      'development': { a: { b: { c: { arr: [4, 5, 6], fu: 'bot' } } }  }

    settings = new Settings(environments)._obj._useEnvironment('development')
    assert.deepEqual [4, 5, 6], settings.a.b.c.arr
    assert.deepEqual 'baz', settings.a.b.c.bah
    assert.deepEqual 'bar', settings.a.b.bar
    assert.deepEqual 'bot', settings.a.b.c.fu


  it "should say which environment is current", ->
    settings = instance()
    assert.equal 'common', settings.ENV

    settings = new Settings(__dirname + '/config/environment', env: 'production')
    assert.equal 'production', settings.ENV


    settings = instance()._obj._useEnvironment('test')
    assert.equal 'test', settings.ENV


  it "should accept defaults", ->
    environments =
      'common':
        foo: 'boo'
      'development':
        foo: 'bar'

    options =
      globalKey: '$settings'

      defaults:
        framework:
          views: 'foo/views'
          models: 'foo/models'

    settings = new Settings(environments, options)._obj._useEnvironment('development')
    assert.equal 'foo/views', settings.framework.views


  it "should be overriden from file", ->
    settings = instance()._obj._useEnvironment('test')
    assert.equal 'server_test', settings.storage.database
    assert.equal 'localhost', settings.storage.host
    settings._obj.override __dirname + "/config/override"
    assert.equal 'server_test', settings.storage.database
    assert.equal 'override', settings.storage.host
    settings._obj.override __dirname + "/config/override2"
    assert.equal 'server_test', settings.storage.database
    assert.equal 'override2', settings.storage.host


  it "should override with root", ->
    settings = new Settings(__dirname + '/config/environment', env: 'test')
    assert.equal 'server_test', settings.storage.database
    assert.equal 'localhost', settings.storage.host
    settings._obj.override __dirname + "/config/overrideRoot", 'fubar'
    assert.equal 'server_test', settings.storage.database
    assert.equal 'override', settings.storage.host
    settings._obj.override __dirname + "/config/overrideRoot2", 'bar'
    assert.equal 'server_test', settings.storage.database
    assert.equal 'override2', settings.storage.host

  it "should handle regex literals", ->
    settings = new Settings(__dirname + '/config/environment')
    assert.ok /asdf/ instanceof RegExp
    assert.ok settings.re instanceof RegExp

