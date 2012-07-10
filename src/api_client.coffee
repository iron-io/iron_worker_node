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

    super('iron', 'worker', options, defaultOptions, ['project_id', 'token', 'api_version'])

  version: ->
    "iron_worker_node-#{version} (#{super()})"

  url: ->
    super() + @options.api_version.toString() + '/'

  headers: ->
    _.extend({}, super(), {'Authorization': "OAuth #{@options.token}"})

  tasksCreate: (codeName, payload, options, cb) ->
    parseResponseBind = _.bind(@parseResponse, @)

    @post("projects/#{@options.project_id}/tasks", {'tasks': [_.extend({'code_name': codeName, 'payload': payload}, options)]}, (error, response, body) ->
      parseResponseBind(error, response, body, cb)
    )

module.exports.APIClient = APIClient
