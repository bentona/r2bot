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
###
repository = "bentona/r2bot"
module.exports = (robot) ->
  robot.hear ///pushed to branch master of #{repository}///i, (msg) ->
    msg.send "You just pushed!"
    return
###
module.exports = (robot) ->
  robot.hear /(.*)branch(.*)/i, (msg) ->
    console.log JSON.stringify msg.match
    msg.send "I HEARD SOMETHIN"
    return


