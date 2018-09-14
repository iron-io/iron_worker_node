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
      user_agent: @version()

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

  codesUpload: (options, cb) ->
    needle = require("needle")
    parseResponseBind = _.bind(@parseResponse, this)
    headers =
      multipart: true
      headers: @headers()
    endpoint = @url() + "projects/" + @options.project_id + "/codes"
    needle.post(endpoint, options, headers, (error, response, body) ->
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

  tasksCreate: (tasks, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    tasksFormatted = tasks.map (task) => _.extend(
      {
        code_name: task.codeName,
        payload: if typeof(task.payload) == 'string' then task.payload else JSON.stringify(task.payload)
      },
      task.options
    )

    @post("projects/#{@options.project_id}/tasks", {tasks: tasksFormatted}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  tasksRetry: (id, delay, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @post("projects/#{@options.project_id}/tasks/#{id}/retry", {'delay': delay}, (error, response, body) ->
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

  tasksStdout: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @get("projects/#{@options.project_id}/tasks/#{id}/outlog", {}, (error, response, body) ->
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

  clustersList: (options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @get("clusters", options, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  clustersGet: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @get("clusters/#{id}", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  clustersStats: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @get("clusters/#{id}/stats", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  clustersCreate: (clusterName, memory, disk, options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @post("clusters", _.extend({'name': clusterName, 'memory': memory, 'disk': disk}, options), (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  clustersUpdate: (id, options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @put("clusters/#{id}", options, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  clustersDelete: (id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @delete("clusters/#{id}", {}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

  instanceTerminate: (id, instance_id, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @post("clusters/#{id}/terminate", {"instance_ids": [instance_id]}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

module.exports.APIClient = APIClient
