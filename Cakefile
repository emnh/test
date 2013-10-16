{exec} = require 'child_process'
task 'build', 'Build project from src/*.coffee to lib/*.js', ->
  exec './node_modules/bower/bin/bower install', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'cd static/coffee && ../../node_modules/coffee-script/bin/coffee -c -m *.coffee', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
