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

module.exports = (robot) ->
  robot.hear ///pushed to branch master of bentona/r2bot///i, (msg) ->
    console.log JSON.stringify msg.match
    msg.send "You just pushed!"
    return


