# define all common settings here
exports.common =
  storage:
    host: 'localhost',
    database: 'server_dev',
    user: 'qirogami_user',
    password: 'password'
  re: /^foo$/


# deep merges over common
exports.development = {}

exports.test =
  storage:
    database: 'server_test'

exports.production =
  storage:
    database: 'server_production'
