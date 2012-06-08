# node-settings

Simple, hierarchical environment-based app settings.

## Installation

    npm install settings

## Usage

Configuration file `config.js`

    module.exports = {
      common: {
        storage: {
          host: 'localhost',
          database: 'server_dev',
          user: 'qirogami_user',
          password: 'password'
        }
      },

      // Rest of environments are deep merged over `common`.

      development: {},
      test: {
        storage: {
          database: 'server_test',
          password: 'foo'
        }
      },
      production:  {
        storage: {
          password: 'secret'
        }
      }
    };

Application file `app.js`

    var Settings = require('settings');
    var config = new Settings(require('./config'));
    // inherited from common
    assert.equal(config.storage.host, 'localhost');
    // specific to test
    assert.equal(config.storage.password, 'foo');


### Environments

The environment to use is based on (highest precedence first):

1. `forceEnv` property in config file

        // config/environment.js
        exports.forceEnv = 'production';

2. `$NODE_ENV` environment variable

        NODE_ENV=production node app.js

3. `env` option passed to constructor.

        new Settings(file, {env: 'test'});


### Application Defaults

Property defaults may be preset in code.

    var settings = new Settings(file, {
     defaults: {
       framework: {
         views: 'app/views'
       }
     }
    });
    assert.equal(settings.framework.views, 'app/views');


## Hacking on the source

To compile and test

    npm install bake-bash -g
    npm install -d
    bake test

## Notes

`globalKey` option has been removed. Do this instead

    global.APP = new Settings(file);


## Credits

jQuery library for `support/extend.js` from @FGRibreau


## License

Copyright (C) 2010 by Mario L. Gutierrez <mario@mgutz.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

