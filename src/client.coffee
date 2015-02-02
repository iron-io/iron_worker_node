_ = require('underscore')

apiClient = require('./api_client')

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

  tasksSetProgress: (taskId, options, cb) ->
    @api.tasksSetProgress(taskId, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  tasksWaitFor: (taskId, options, cb) ->
    tasksWaitForBind = _.bind(@tasksWaitFor, @)

    sleep = options.sleep
    sleep = 5 if not sleep?

    @tasksGet(taskId, (error, body) ->
      if not error?
        if body.status == 'queued' or body.status == 'running'
          _.delay(tasksWaitForBind, sleep * 1000, taskId, options, cb)
        else
          cb(error, body)
      else
        cb(error, body)
    )

  tasksWaitForLog: (taskId, options, cb) ->
    tasksWaitForLogBind = _.bind(@tasksWaitForLog, @)
    options.sleep ?= 5

    @tasksLog(taskId, (error, body) ->
      if error and error.message.match(/log/i)
        _.delay(tasksWaitForLogBind, options.sleep * 1000, taskId, options, cb)
      else
        cb(error, body)
    )

  schedulesList: (options, cb) ->
    @api.schedulesList(options, (error, body) ->
      if not error?
        cb(error, body.tasks)
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

module.exports.Client = Client
