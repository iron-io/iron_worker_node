iron_worker_node is NODE.JS language binding for IronWorker.

IronWorker is a massively scalable background processing system.
[See How It Works](http://www.iron.io/products/worker/how)

# Getting Started


1\. Install the module:

```
npm install iron_worker
```

2\. [Setup your Iron.io credentials](http://dev.iron.io/mq/reference/configuration/)

3\. Create an IronWorker Client object:

```javascript
var iron_worker = require('iron_worker');
var worker = new iron_worker.Client();
```

Or pass in credentials:

```javascript
var worker = new iron_worker.Client({token: "MY_TOKEN", project_id: "MY_PROJECT_ID"});
```

## Creating a Worker

Here's an example worker:

```javascript
console.log("Hello Node World!");
```

## Upload code to server

### Using CLI tool (preferred)

* Get [CLI](http://dev.iron.io/worker/reference/cli) tool
* Download or create `iron.json` config file with project_id/password
* Create `HelloWorld.worker` file, example:

```ruby
runtime 'node'
exec 'HelloWorld.js'
```
* Upload!

```sh
$ iron_worker upload HelloWorld
```

[.worker syntax reference](http://dev.iron.io/worker/reference/dotworker/)

### Parsing payload, config within running worker

* Add this library to list of dependencies (`package.json`):
* Use it:

```javascript
var iron_worker = require('iron_worker');
console.log(iron_worker.params());
console.log(iron_worker.config());
console.log(iron_worker.taskId());
```

## Worker examples

You can find plenty of good worker examples here: [iron_worker_examples](https://github.com/iron-io/iron_worker_examples/tree/master/node)

## Queueing a Worker

```javascript
worker.tasksCreate('HelloWorld', {}, {}, function(err,res){
  task_id = res.id;
  console.log("Pushed new task: task_id = "+task_id);
});
```
Worker should start in a few seconds.

If you need to pass some data you can use payload parameter

```javascript
var payload = {first: 'Hello', second: 'World'};
var options = {priority: 1};
worker.tasksCreate('HelloWorld', payload, options, function(error, body) {});
```

### Queueing Options

  - **priority**: Setting the priority of your job. Valid values are 0, 1, and 2. The default is 0.
  - **timeout**: The maximum runtime of your task in seconds. No task can exceed 3600 seconds (60 minutes). The default is 3600 but can be set to a shorter duration.
  - **delay**: The number of seconds to delay before actually queuing the task. Default is 0.
  - **label**: Optional text label for your task.
  - **cluster**: cluster name ex: "high-mem" or "dedicated".  This is a premium feature for customers to have access to more powerful or custom built worker solutions. Dedicated worker clusters exist for users who want to reserve a set number of workers just for their queued tasks. If not set default is set to  "default" which is the public IronWorker cluster.


## Status of a Worker
To get the status of a task and other info, you can use the ```tasksGet()``` method.

```javascript
worker.tasksCreate('HelloWorld', {}, {}, function(err,res){
  task_id = res.id;
  worker.tasksGet(task_id, function(error, res) {
    console.log("Full info about the task:\n"+JSON.stringify(res));
  });
});
```

## Get Worker Log

Use any function that print text inside your worker to put messages to log.

```javascript
worker.tasksCreate('HelloWorld', {}, {}, function(err,res){
  task_id = res.id;
  worker.tasksWaitForLog(task_id, {}, function (err, res) {
    worker.tasksLog(task_id, function (err, res) {console.log(res)});
  })
});
```

## Scheduling a Worker

Like with `tasksCreate`

```javascript
worker.schedulesCreate('HelloWorld', payload, {run_times: 10}, function(error, body) {});
```

### Scheduling Options

  - **run_every**: The amount of time, in seconds, between runs. By default, the task will only run once. run_every will return a 400 error if it is set to less than 60.
  - **end_at**: The time tasks will stop being queued.
  - **run_times**: The number of times a task will run.
  - **priority**: Setting the priority of your job. Valid values are 0, 1, and 2. The default is 0. Higher values means tasks spend less time in the queue once they come off the schedule.
  - **start_at**: The time the scheduled task should first be run.
  - **label**: Optional text label for your task.
  - **cluster**: cluster name ex: "high-mem" or "dedicated".


# Full Documentation

You can find more documentation here:

* http://dev.iron.io Full documetation for iron.io products.
* [IronWorker Node Examples](https://github.com/iron-io/dockerworker/tree/master/node)
