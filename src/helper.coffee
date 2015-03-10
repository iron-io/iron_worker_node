_ = require('underscore')

params = null
task_id = null
config = null

parseCLIData = ->
  fs = require('fs')
  querystring = require('querystring')

  process.argv.forEach (val, index, array) ->
    if val == "-payload"
      params = fs.readFileSync(process.argv[index + 1], 'utf8')
      try
        params = JSON.parse(params)
      catch e
        try
          parsed = querystring.parse(params)
          if !(Object.keys(parsed).length == 1 && parsed[Object.keys(parsed)[0]] == '')
            params = parsed
        catch e

    if val == "-config"
      config = fs.readFileSync(process.argv[index + 1], 'utf8')
      try
        config = JSON.parse(config)
      catch e

    if val == "-id"
      task_id = process.argv[index + 1]

module.exports.params = ->
  parseCLIData() if !params
  params

module.exports.taskId = ->
  parseCLIData() if !task_id
  task_id

module.exports.config = ->
  parseCLIData() if !config
  config

