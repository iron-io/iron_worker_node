_ = require('underscore')

params = null
task_id = null
config = null
task_dir = null
payload_file = null

parseCLIData = ->
  fs = require('fs')
  querystring = require('querystring')

  process.argv.forEach (val, index, array) ->
    if val == "-payload"
      payload_file = process.argv[index + 1]

    if val == "-config"
      config_file = process.argv[index + 1]

    if val == "-id"
      task_id = process.argv[index + 1]

    if val == "-d"
      task_dir = process.argv[index + 1]

  task_id = process.env.TASK_ID if process.env.TASK_ID
  task_dir = process.env.TASK_DIR if process.env.TASK_DIR
  payload_file = process.env.PAYLOAD_FILE if process.env.PAYLOAD_FILE
  config_file = process.env.CONFIG_FILE if process.env.CONFIG_FILE

  if payload_file?
    params = fs.readFileSync(payload_file, 'utf8')
    try
      params = JSON.parse(params)
    catch e
      try
        parsed = querystring.parse(params)
        if !(Object.keys(parsed).length == 1 && parsed[Object.keys(parsed)[0]] == '')
          params = parsed
      catch e

  if config_file?
    config = fs.readFileSync(config_file, 'utf8')
    try
      config = JSON.parse(config)
    catch e

module.exports.params = ->
  parseCLIData() if !params
  params

module.exports.taskId = ->
  parseCLIData() if !task_id
  task_id

module.exports.config = ->
  parseCLIData() if !config
  config

