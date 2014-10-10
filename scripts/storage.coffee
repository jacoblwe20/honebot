# Description:
#   Inspect the data in redis easily
#
# Commands:
#   hubot show users - Display all users that hubot knows about
#   hubot show storage - Display the contents that are persisted in the brain


Util = require "util"

module.exports = (robot) ->
  robot.respond /show storage$/i, (msg) ->
    if 'admin' in msg.message.user.roles 
      output = Util.inspect(robot.brain.data, false, 4)
      msg.send output
    else
      msg.send 'Sorry @' + msg.message.user.name + ', only admins can access this command.'

  robot.respond /show users$/i, (msg) ->

    if 'admin' in msg.message.user.roles 
      response = ""
      for own key, user of robot.brain.data.users
        response += "#{user.id} #{user.name}"
        response += " <#{user.email_address}>" if user.email_address
        response += "\n"

      msg.send response

    else
      msg.send 'Sorry @' + msg.message.user.name + ', only admins can access this command.'

  robot.respond /what do you know about me\?*$/i, ( msg ) ->
    user = robot.auth.getUserByName( msg.message.user.name )
    if user
      msg.reply Util.inspect( user, false, 4 )
    else
      msg.reply 'Nothing your off the grid ;-)'

