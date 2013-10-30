# Description:
#   Hubot delivers a pic from Reddit's /r/aww frontpage
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   aww - Display the picture from /r/aww
#
# Author:
#   eliperkins

repository = "bentona/r2bot"
module.exports = (robot) ->
  robot.respond ///pushed to branch master of #{repository}///i, (msg) ->
    msg.send "You just pushed!"
    return
