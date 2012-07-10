apiClient = require('./api_client')

class Client
  constructor: (options) ->
    @api = new apiClient.APIClient(options)

  tasksCreate: (codeName, params, options, cb) ->
    payload = ''
    
    if typeof(params) == 'string'
      payload = params
    else
      payload = JSON.stringify(params)

    @api.tasksCreate(codeName, payload, options, (error, body) ->
      if not error?
        cb(error, body.tasks[0])
      else
        cb(error, body)
    )

module.exports.Client = Client
