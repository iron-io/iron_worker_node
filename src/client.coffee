_ = require('underscore')

apiClient = require('./api_client')
helper = require('./helper')

class Client
  constructor: (options) ->
    @api = new apiClient.APIClient(options)

  codesList: (options, cb) ->
    @api.codesList(options, (error, body) ->
      if not error?
        cb(error, body.codes)
      else
        cb(error, body)
    )

  codesGet: (codeId, cb) ->
    @api.codesGet(codeId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  codesDelete: (codeId, cb) ->
    @api.codesDelete(codeId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  codesRevisions: (codeId, options, cb) ->
    @api.codesRevisions(codeId, options, (error, body) ->
      if not error?
        cb(error, body.revisions)
      else
        cb(error, body)
    )

  codesDownload: (codeId, options, cb) ->
    @api.codesDownload(codeId, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  tasksList: (options, cb) ->
    @api.tasksList(options, (error, body) ->
      if not error?
        cb(error, body.tasks)
      else
        cb(error, body)
    )

  tasksGet: (taskId, cb) ->
    @api.tasksGet(taskId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

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

  tasksRetry: (taskId, delay, cb) ->
    @api.tasksRetry(taskId, delay, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  tasksCancel: (taskId, cb) ->
    @api.tasksCancel(taskId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  tasksCancelAll: (codeId, cb) ->
    @api.tasksCancelAll(codeId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  tasksLog: (taskId, cb) ->
    @api.tasksLog(taskId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  tasksStdout: (taskId, cb) ->
    @api.tasksStdout(taskId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  tasksSetProgress: (taskId, options, cb) ->
    @api.tasksSetProgress(taskId, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  tasksWaitFor: (taskId, options, cb) ->
    tasksWaitForBind = _.bind(@tasksWaitFor, @)

    options.sleep ?= 0.25
    options.timeout ?= 3600
    options.tries ?= Math.round((options.timeout) / 60) + 20
    options.tries--
    if options.tries < 0
      return cb(new Error('Timeout waiting for task execution'), null)

    @tasksGet(taskId, (error, body) ->
      if not error?
        setDelayBetweenRetries(options)
        if body.status == 'queued' or body.status == 'preparing' or body.status == 'running'
          _.delay(tasksWaitForBind, options.sleep * 1000, taskId, options, cb)
        else
          cb(error, body)
      else
        cb(error, body)
    )

  tasksWaitForLog: (taskId, options, cb) ->
    tasksWaitForLogBind = _.bind(@tasksWaitForLog, @)
    options.sleep ?= 0.25
    options.tries ?= 10
    options.tries--
    if options.tries < 0
      return cb(new Error('Timeout waiting for task log'), null)

    @tasksLog(taskId, (error, body) ->
      if error and error.message.match(/log/i)
        setDelayBetweenRetries(options)
        _.delay(tasksWaitForLogBind, options.sleep * 1000, taskId, options, cb)
      else
        cb(error, body)
    )

  tasksWaitForSyncTaskStdout: (taskId, options, cb) ->
    tasksWaitForSyncTaskStdoutBind = _.bind(@tasksWaitForSyncTaskStdout, @)
    options.sleep ?= 0.25
    options.tries ?= 10
    options.tries--
    if options.tries < 0
      return cb(new Error('Timeout waiting for task stdout'), null)

    @tasksStdout(taskId, (error, body) ->
      if error and error.message.match(/log/i)
        setDelayBetweenRetries(options)
        _.delay(tasksWaitForSyncTaskStdoutBind, options.sleep * 1000, taskId, options, cb)
      else
        cb(error, body)
    )

  tasksRun: (codeName, params, options, cb) ->
    options.sync = true
    tasksWaitForBind = _.bind(@tasksWaitFor, @)
    tasksWaitForSyncTaskStdoutBind = _.bind(@tasksWaitForSyncTaskStdout, @)

    @tasksCreate(codeName, params, options, (error, body) ->
      if error
        cb(error, body)
      else
        task_id = body.id
        tasksWaitForBind(task_id, {}, (error, body) ->
          if error
            cb(error, body)
          else
            tasksWaitForSyncTaskStdoutBind(task_id, {}, (error, body) ->
              if error
                cb(error, body)
              else
                cb(error, body)
            )
        )
    )

  schedulesList: (options, cb) ->
    @api.schedulesList(options, (error, body) ->
      if not error?
        cb(error, body.schedules)
      else
        cb(error, body)
    )

  schedulesGet: (scheduleId, cb) ->
    @api.schedulesGet(scheduleId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  schedulesCreate: (codeName, params, options, cb) ->
    payload = ''

    if typeof(params) == 'string'
      payload = params
    else
      payload = JSON.stringify(params)

    @api.schedulesCreate(codeName, payload, options, (error, body) ->
      if not error?
        cb(error, body.schedules[0])
      else
        cb(error, body)
    )

  schedulesCancel: (scheduleId, cb) ->
    @api.schedulesCancel(scheduleId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  codesUpload: (name, destination, fileName, cb) ->
    needle = require("needle")
    ncp = require("ncp").ncp
    fs = require("fs")
    AdmZip = require("adm-zip")
    zip = new AdmZip()
    destination += "/"  unless destination.charAt(destination.length - 1) is "/"
    api = @api
    ncp.limit = 16
    ncp "upload_files", destination, (err) ->
      throw err  if err
      fs.appendFile destination + "__runner__.sh", "\nnode " + fileName, (err) ->
        throw err  if err
        zip.addLocalFolder destination
        params =
          data: JSON.stringify(
            name: name
            file_name: "__runner__.sh"
            runtime: "sh"
            content_type: "text/plain"
          )
          file:
            buffer: zip.toBuffer()
            content_type: "application/zip"

        api.codesUpload params, (err, body) ->
          unless err?
            cb err, body
          else
            cb err, body

  clustersList: (options, cb) ->
    @api.clustersList(options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  clustersGet: (clusterId, cb) ->
    @api.clustersGet(clusterId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  clustersStats: (clusterId, cb) ->
    @api.clustersStats(clusterId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  clustersCreate: (clusterName, memory, disk, options, cb) ->
    @api.clustersCreate(clusterName, memory, disk, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  clustersUpdate: (clusterId, options, cb) ->
    @api.clustersUpdate(clusterId, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  clustersDelete: (clusterId, cb) ->
    @api.clustersDelete(clusterId, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  instanceTerminate: (clusterId, instance_id, cb) ->
    @api.instanceTerminate(clusterId, instance_id, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  setDelayBetweenRetries = (options) ->
    if options.sleep < 60
      options.sleep *= 2

module.exports.Client = Client
module.exports.params = helper.params
module.exports.config = helper.config
module.exports.taskId = helper.taskId
module.exports.taskDir = helper.taskDir