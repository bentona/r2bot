# Description:
#   Reloads scripts when github notification of push to master is sent
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   (none)
#
# Author:
#   bentona

repository = "bentona/r2bot"
module.exports = (robot) ->
  robot.respond ///pushed to branch master of #{repository}///i, (msg) ->
    msg.send "You just pushed!"
    return
