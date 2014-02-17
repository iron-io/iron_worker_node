iron_worker_node is NODE.JS language binding for IronWorker.

IronWorker is a massively scalable background processing system.
[See How It Works](http://www.iron.io/products/worker/how)

# Getting Started


1\. Install the gem:

```
npm install iron_worker
```

2\. [Setup your Iron.io credentials](http://dev.iron.io/mq/reference/configuration/)

3\. Create an IronMQ Client object:

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

## Worker examples

You can find plenty of good worker examples here: [iron_worker_examples](https://github.com/iron-io/iron_worker_examples/tree/master/node)

## Queueing a Worker

```javascript
var task_id = worker.tasksCreate('HelloWorld');
```
Worker should start in a few seconds.


## Status of a Worker
To get the status of a worker, you can use the ```tasksGet()``` method.

```javascript
var task_id = worker.tasksCreate('HelloWorld');
details = worker.tasksGet(task_id);
```

## Get Worker Log

Use any function that print text inside your worker to put messages to log.

```javascript
var task_id = worker.tasksCreate('HelloWorld');
worker.tasksWaitFor(task_id, function (err, res) {
    worker.tasksLog(task_id, function (err, res) {console.log(res)});
})
```

# Full Documentation

You can find more documentation here:

* http://dev.iron.io Full documetation for iron.io products.
* [IronWorker Node Examples](https://github.com/iron-io/iron_worker_examples/tree/master/node)
