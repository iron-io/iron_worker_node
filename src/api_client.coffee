require('pkginfo')(module)
version = @version

_ = require('underscore')

ironCore = require('iron_core');

class APIClient extends ironCore.Client
  AWS_US_EAST_HOST: 'worker-aws-us-east-1.iron.io'

  constructor: (options) ->
    defaultOptions =
      scheme: 'https',
      host: @AWS_US_EAST_HOST,
      port: 443,
      api_version: 2,
      user_agent: @version

    super('iron', 'worker', options, defaultOptions, ['project_id', 'token', 'api_version'])

  version: ->
    "iron_worker_node-#{version} (#{super()})"

  url: ->
    super() + @options.api_version.toString() + '/'

  headers: ->
    _.extend({}, super(), {'Authorization': "OAuth #{@options.token}"})

  codesList: (options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @get("projects/#{@options.project_id}/codes", options, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  codesGet: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @get("projects/#{@options.project_id}/codes/#{id}", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  codesDelete: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @delete("projects/#{@options.project_id}/codes/#{id}", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb, false)
    )

  codesRevisions: (id, options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @get("projects/#{@options.project_id}/codes/#{id}/revisions", options, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  codesDownload: (id, options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @get("projects/#{@options.project_id}/codes/#{id}/download", options, (error, response, body) ->
      parseResponseBind(error, response, body, cb, false)
    )

  tasksList: (options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @get("projects/#{@options.project_id}/tasks", options, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  tasksGet: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @get("projects/#{@options.project_id}/tasks/#{id}", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  tasksCreate: (codeName, payload, options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @post("projects/#{@options.project_id}/tasks", {'tasks': [_.extend({'code_name': codeName, 'payload': payload}, options)]}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  tasksCancel: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @post("projects/#{@options.project_id}/tasks/#{id}/cancel", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  tasksCancelAll: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @post("projects/#{@options.project_id}/codes/#{id}/cancel_all", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  tasksLog: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @get("projects/#{@options.project_id}/tasks/#{id}/log", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb, false)
    )

  tasksSetProgress: (id, options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @post("projects/#{@options.project_id}/tasks/#{id}/progress", options, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  schedulesList: (options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @get("projects/#{@options.project_id}/schedules", options, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  schedulesGet: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @get("projects/#{@options.project_id}/schedules/#{id}", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  schedulesCreate: (codeName, payload, options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @post("projects/#{@options.project_id}/schedules", {'schedules': [_.extend({'code_name': codeName, 'payload': payload}, options)]}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  schedulesCancel: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)
        
    @post("projects/#{@options.project_id}/schedules/#{id}/cancel", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

module.exports.APIClient = APIClient
