// Generated by CoffeeScript 1.3.3
(function() {
  var APIClient, ironCore, version, _,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  require('pkginfo')(module);

  version = this.version;

  _ = require('underscore');

  ironCore = require('iron_core');

  APIClient = (function(_super) {

    __extends(APIClient, _super);

    APIClient.prototype.AWS_US_EAST_HOST = 'worker-aws-us-east-1.iron.io';

    function APIClient(options) {
      var defaultOptions;
      defaultOptions = {
        scheme: 'https',
        host: this.AWS_US_EAST_HOST,
        port: 443,
        api_version: 2,
        user_agent: this.version
      };
      APIClient.__super__.constructor.call(this, 'iron', 'worker', options, defaultOptions, ['project_id', 'token', 'api_version']);
    }

    APIClient.prototype.version = function() {
      return "iron_worker_node-" + version + " (" + (APIClient.__super__.version.call(this)) + ")";
    };

    APIClient.prototype.url = function() {
      return APIClient.__super__.url.call(this) + this.options.api_version.toString() + '/';
    };

    APIClient.prototype.headers = function() {
      return _.extend({}, APIClient.__super__.headers.call(this), {
        'Authorization': "OAuth " + this.options.token
      });
    };

    APIClient.prototype.codesList = function(options, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.get("projects/" + this.options.project_id + "/codes", options, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.codesGet = function(id, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.get("projects/" + this.options.project_id + "/codes/" + id, {}, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.codesDelete = function(id, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this["delete"]("projects/" + this.options.project_id + "/codes/" + id, {}, function(error, response, body) {
        return parseResponseBind(error, response, body, cb, false);
      });
    };

    APIClient.prototype.codesRevisions = function(id, options, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.get("projects/" + this.options.project_id + "/codes/" + id + "/revisions", options, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.codesDownload = function(id, options, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.get("projects/" + this.options.project_id + "/codes/" + id + "/download", options, function(error, response, body) {
        return parseResponseBind(error, response, body, cb, false);
      });
    };

    APIClient.prototype.tasksList = function(options, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.get("projects/" + this.options.project_id + "/tasks", options, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.tasksGet = function(id, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.get("projects/" + this.options.project_id + "/tasks/" + id, {}, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.tasksCreate = function(codeName, payload, options, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.post("projects/" + this.options.project_id + "/tasks", {
        'tasks': [
          _.extend({
            'code_name': codeName,
            'payload': payload
          }, options)
        ]
      }, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.tasksCancel = function(id, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.post("projects/" + this.options.project_id + "/tasks/" + id + "/cancel", {}, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.tasksCancelAll = function(id, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.post("projects/" + this.options.project_id + "/codes/" + id + "/cancel_all", {}, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.tasksLog = function(id, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.get("projects/" + this.options.project_id + "/tasks/" + id + "/log", {}, function(error, response, body) {
        return parseResponseBind(error, response, body, cb, false);
      });
    };

    APIClient.prototype.tasksSetProgress = function(id, options, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.post("projects/" + this.options.project_id + "/tasks/" + id + "/progress", options, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.schedulesList = function(options, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.get("projects/" + this.options.project_id + "/schedules", options, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.schedulesGet = function(id, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.get("projects/" + this.options.project_id + "/schedules/" + id, {}, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.schedulesCreate = function(codeName, payload, options, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.post("projects/" + this.options.project_id + "/schedules", {
        'schedules': [
          _.extend({
            'code_name': codeName,
            'payload': payload
          }, options)
        ]
      }, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    APIClient.prototype.schedulesCancel = function(id, cb) {
      var parseResponseBind;
      parseResponseBind = _.bind(this.parseResponse, this);
      return this.post("projects/" + this.options.project_id + "/schedules/" + id + "/cancel", {}, function(error, response, body) {
        return parseResponseBind(error, response, body, cb);
      });
    };

    return APIClient;

  })(ironCore.Client);

  module.exports.APIClient = APIClient;

}).call(this);