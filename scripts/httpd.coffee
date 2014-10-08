# Description:
#   A simple interaction with the built in HTTP Daemon
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   /hubot/version
#   /hubot/ping
#   /hubot/time
#   /hubot/info
#   /hubot/ip

spawn = require('child_process').spawn

module.exports = (robot) ->

  robot.brain.sent = robot.brain.sent || []

  robot.router.get "/hubot/version", (req, res) ->
    res.end robot.version

  robot.router.post "/hubot/ping", (req, res) ->
    res.end "PONG"

  robot.router.get "/hubot/time", (req, res) ->
    res.end "Server time is: #{new Date()}"

  robot.router.get "/hubot/info", (req, res) ->
    child = spawn('/bin/sh', ['-c', "echo I\\'m $LOGNAME@$(hostname):$(pwd) \\($(git rev-parse HEAD)\\)"])

    child.stdout.on 'data', (data) ->
      res.end "#{data.toString().trim()} running node #{process.version} [pid: #{process.pid}]"
      child.stdin.end()

  robot.router.get "/hubot/ip", (req, res) ->
    robot.http('http://ifconfig.me/ip').get() (err, r, body) ->
      res.end body

  robot.router.post "/hubot/echo", (req, res) ->
    room = req.body.room || '#general'
    text = req.body.text
    id = req.body.id
    type = req.body.eventType

    if type is 'error'
      robot.messageRoom room, text
      res.end 'sent'
    else if id not in robot.brain.sent
      if type is 'restart'
        text = text + ' | <a href="http://github.com/honeinc/hone/commit/' + id + '">' + id + '</a>' 
      robot.messageRoom room, text
      res.end 'sent'
      robot.brain.sent.push id
