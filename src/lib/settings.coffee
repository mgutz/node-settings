#
# Copyright(c) 2010-2013 Mario L Gutierrez <mario@mgutz.com>
# MIT Licensed
#

assert = require('assert')
Extend = require('../support/extend')
Path = require('path')

loadModule = (pathOrModule) ->
  if typeof pathOrModule == 'string'
    require('coffee-script') if Path.extname(pathOrModule) == '.coffee'
    mod = require(pathOrModule)
  else
    mod = pathOrModule
  mod


# TODO - add watcher on settings file

# Provides settings from an environment file or an object.
#
# The settings module must export, at a minimum, a `common` property.
#
# Other environments are deep merged into `common`.
#
# @param {String | Object} pathOrModule The file to load or an object.
#
# @example
#
# exports.common = {connectionString: 'mysql_dev'};
#
# exports.development = {};
# exports.test = {connectionString: 'mysql_test'};
#
# development.connectionString === 'mysql_dev';
# test.connectionString === 'mysql_test';
#
Settings = (pathOrModule, @options = {}) ->
  if typeof pathOrModule == 'string'
    @path = pathOrModule

  @environments = loadModule(pathOrModule)
  @_useEnvironment @options.env, @options.root
  @_settings


# Get settings for a specific environment.
#
# @param {String} environ [optional] The environment to retrieve.
#
# If `environ` is not passed, an environment is selected in this order
#
#  1. Module's `forceEnv` property
#  2. $NODE_ENV environment variable
#  3. `common` environment
#
Settings.prototype._useEnvironment = (environ, root) ->
  if environ?
    environ = undefined if !@environments[environ]
  @env = @environments.forceEnv || environ || process.env.NODE_ENV || 'common'

  assert.ok @environments.common, 'Environment common not found in: ' + @path
  assert.ok @environments[@env], 'Environment `' + @env + '` not found in: ' + @path

  if @options.defaults?
    common = Extend.cloneExtend(@options.defaults,  @environments.common)
  else
    common = Extend.clone(@environments.common)

  if @env == 'common'
    result = common
  else
    result = Extend.extend(common, @environments[@env])

  @_setSettingsScope result, root


# Override settings from path or module with an option to specify
# a property as `root`.
#
# @param pathOrModule {String | Object} The path or module.
# @param root {String} [optional] The property to use as root.
# @returns A settings object.
Settings.prototype.override = (pathOrModule, root) ->
  mod = loadModule(pathOrModule)
  if mod.common?
    mod = new Settings(mod, env: @env)
    mod._obj = null

  if root?
    console.assert mod[root]?, "configuration root property not found: "+root
    mod = mod[root]

  Extend.extend @_settings, mod
  @_settings._obj = this


# Sets internal settings to `settings` with the option to
# use a property as `root`.
#
# @param settings {Object} The object whose properties become the settings.
#                          If this is null, then existing settings are used.
# @param root {String} The root name.
# @returns A settings object.
Settings.prototype._setSettingsScope = (settings, root) ->
  if root?
    @root = root
  @_settings = if root? then settings[root] else settings
  @_settings._obj = this
  @_settings.ENV = @env
  @_settings


module.exports = Settings

